"""Export the complete Prism Central v3 VM inventory to CSV.

Author: Paul Bryant
"""

import argparse
import csv

from prism_client import PrismClient


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--env", default=".env")
    parser.add_argument("--csv", required=True)
    args = parser.parse_args(argv)

    with PrismClient.from_env(args.env) as client:
        vms = list(client.list_entities("vm"))

    with open(args.csv, "w", newline="", encoding="utf-8") as stream:
        writer = csv.writer(stream)
        writer.writerow(["VMName", "UUID", "PowerState", "Categories"])
        for vm in vms:
            spec = vm.get("spec", {})
            metadata = vm.get("metadata", {})
            status = vm.get("status", {})
            categories = metadata.get("categories_mapping", {})
            writer.writerow([
                spec.get("name", ""),
                metadata.get("uuid", ""),
                status.get("power_state", ""),
                ",".join(sorted(categories)),
            ])
    print(f"Exported {len(vms)} VMs to {args.csv}")


if __name__ == "__main__":
    main()
