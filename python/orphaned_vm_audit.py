"""Report VMs that merit review based on simple inventory signals.

These signals do not establish that a VM is orphaned. Author: Paul Bryant.
"""

import argparse
import csv

from prism_client import PrismClient


def review_reasons(vm):
    status = vm.get("status", {})
    metadata = vm.get("metadata", {})
    reasons = []
    if status.get("power_state") == "OFF":
        reasons.append("powered_off")
    if not metadata.get("categories_mapping"):
        reasons.append("no_categories")
    if not status.get("protection_domain"):
        reasons.append("no_protection_domain_in_response")
    return reasons


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--env", default=".env")
    parser.add_argument("--csv", required=True)
    args = parser.parse_args(argv)

    with PrismClient.from_env(args.env) as client:
        vms = list(client.list_entities("vm"))

    count = 0
    with open(args.csv, "w", newline="", encoding="utf-8") as stream:
        writer = csv.writer(stream)
        writer.writerow(["VMName", "UUID", "PowerState", "Categories", "ProtectionDomain", "ReviewReasons"])
        for vm in vms:
            reasons = review_reasons(vm)
            if not reasons:
                continue
            metadata = vm.get("metadata", {})
            status = vm.get("status", {})
            writer.writerow([
                vm.get("spec", {}).get("name", ""),
                metadata.get("uuid", ""),
                status.get("power_state", ""),
                ",".join(sorted(metadata.get("categories_mapping", {}))),
                status.get("protection_domain", ""),
                ",".join(reasons),
            ])
            count += 1
    print(f"Exported {count} review candidates to {args.csv}")


if __name__ == "__main__":
    main()
