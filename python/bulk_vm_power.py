"""Preview or request VM power changes through Prism Central v3.

CSV columns: VMName,Action where Action is ON or OFF.
Author: Paul Bryant.
"""

import argparse
import csv
from copy import deepcopy

from prism_client import PrismClient


def read_actions(path):
    actions = []
    seen = set()
    with open(path, newline="", encoding="utf-8-sig") as stream:
        reader = csv.DictReader(stream)
        if not reader.fieldnames or not {"VMName", "Action"}.issubset(reader.fieldnames):
            raise ValueError("CSV requires VMName,Action")
        for row in reader:
            name = (row["VMName"] or "").strip()
            action = (row["Action"] or "").strip().upper()
            if not name or action not in {"ON", "OFF"}:
                raise ValueError(f"Invalid VM name or action: {row!r}")
            if name in seen:
                raise ValueError(f"VM {name!r} appears more than once")
            seen.add(name)
            actions.append((name, action))
    if not actions:
        raise ValueError("CSV contains no power actions")
    return actions


def with_power_state(vm, state):
    updated = deepcopy(vm)
    updated.pop("status", None)
    updated.setdefault("spec", {}).setdefault("resources", {})["power_state"] = state
    return updated


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--csv", required=True)
    parser.add_argument("--env", default=".env")
    parser.add_argument("--apply", action="store_true", help="Submit the listed power actions")
    args = parser.parse_args(argv)
    actions = read_actions(args.csv)

    with PrismClient.from_env(args.env) as client:
        vms_by_name = {}
        for vm in client.list_entities("vm"):
            vms_by_name.setdefault(vm.get("spec", {}).get("name"), []).append(vm)
        resolved = []
        for name, action in actions:
            matches = vms_by_name.get(name, [])
            if len(matches) != 1:
                raise ValueError(f"Expected one VM named {name!r}; found {len(matches)}")
            uuid = matches[0]["metadata"]["uuid"]
            resolved.append((name, uuid, action))
            print(f"{name} ({uuid}): {action}")
        if not args.apply:
            print("Preview only. Rerun with --apply to submit these power actions.")
            return

        updates = []
        for name, uuid, action in resolved:
            current = client.get(f"vms/{uuid}").json()
            current_state = current.get("spec", {}).get("resources", {}).get("power_state")
            if current_state == action:
                print(f"{name}: already {action}")
                continue
            updates.append((name, uuid, with_power_state(current, action)))

        for name, uuid, updated in updates:
            response = client.put(f"vms/{uuid}", updated)
            payload = response.json()
            task_id = payload.get("status", {}).get("execution_context", {}).get("task_uuid")
            print(f"{name}: request accepted; task={task_id or 'not returned'}")


if __name__ == "__main__":
    main()
