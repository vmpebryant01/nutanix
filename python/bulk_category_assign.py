"""Preview or assign Prism Central v3 category key/value pairs to VMs.

CSV columns: VMName,CategoryKey,CategoryValue. Author: Paul Bryant.
"""

import argparse
import csv
from copy import deepcopy
from urllib.parse import quote

from prism_client import PrismClient


def read_rows(path):
    with open(path, newline="", encoding="utf-8-sig") as stream:
        reader = csv.DictReader(stream)
        required = {"VMName", "CategoryKey", "CategoryValue"}
        if not reader.fieldnames or not required.issubset(reader.fieldnames):
            raise ValueError("CSV requires VMName,CategoryKey,CategoryValue")
        rows = []
        seen = set()
        for row in reader:
            name, key, value = ((row[column] or "").strip() for column in ("VMName", "CategoryKey", "CategoryValue"))
            if not all((name, key, value)):
                raise ValueError("CSV contains a blank VM name, key, or value")
            identity = (name, key, value)
            if identity in seen:
                raise ValueError(f"Duplicate assignment: {identity}")
            seen.add(identity)
            rows.append(identity)
    if not rows:
        raise ValueError("CSV contains no assignments")
    return rows


def with_category(vm, key, value):
    updated = deepcopy(vm)
    updated.pop("status", None)
    metadata = updated.setdefault("metadata", {})
    mapping = metadata.setdefault("categories_mapping", {})
    existing = mapping.get(key, [])
    if isinstance(existing, str):
        existing = [existing]
    mapping[key] = list(dict.fromkeys([*existing, value]))
    metadata["use_categories_mapping"] = True
    return updated


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--csv", required=True)
    parser.add_argument("--env", default=".env")
    parser.add_argument("--apply", action="store_true", help="Write validated assignments")
    args = parser.parse_args(argv)
    rows = read_rows(args.csv)

    with PrismClient.from_env(args.env) as client:
        vms_by_name = {}
        for vm in client.list_entities("vm"):
            vms_by_name.setdefault(vm.get("spec", {}).get("name"), []).append(vm)
        for name, key, value in rows:
            matches = vms_by_name.get(name, [])
            if len(matches) != 1:
                raise ValueError(f"Expected one VM named {name!r}; found {len(matches)}")
            print(f"{name}: add {key}:{value}")
        if not args.apply:
            print("Preview only. Rerun with --apply to update these VMs.")
            return

        checked_categories = set()
        for name, key, value in rows:
            if (key, value) not in checked_categories:
                client.get(f"categories/{quote(key, safe='')}/{quote(value, safe='')}")
                checked_categories.add((key, value))
        assignments = {}
        for name, key, value in rows:
            assignments.setdefault(name, []).append((key, value))
        updates = []
        for name, pairs in assignments.items():
            uuid = vms_by_name[name][0]["metadata"]["uuid"]
            current = client.get(f"vms/{uuid}").json()
            updated = current
            for key, value in pairs:
                updated = with_category(updated, key, value)
            if updated.get("metadata", {}).get("categories_mapping") == current.get("metadata", {}).get("categories_mapping"):
                print(f"{name}: categories already assigned")
                continue
            updates.append((name, uuid, updated))

        for name, uuid, updated in updates:
            response = client.put(f"vms/{uuid}", updated)
            task_id = response.json().get("status", {}).get("execution_context", {}).get("task_uuid")
            print(f"{name}: update accepted; task={task_id or 'not returned'}")


if __name__ == "__main__":
    main()
