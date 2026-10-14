"""Export Prism Central VM recovery points and their full records to CSV.

Recovery points are distinct from Prism Element VM snapshots.
Author: Paul Bryant
"""

import argparse
import csv
import json

from prism_client import PrismClient


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--env", default=".env")
    parser.add_argument("--csv", required=True)
    args = parser.parse_args(argv)

    with PrismClient.from_env(args.env) as client:
        recovery_points = list(client.list_entities("vm_recovery_point"))

    with open(args.csv, "w", newline="", encoding="utf-8") as stream:
        writer = csv.writer(stream)
        writer.writerow(["RecoveryPointName", "UUID", "Created", "RawEntityJSON"])
        for point in recovery_points:
            metadata = point.get("metadata", {})
            writer.writerow([
                point.get("spec", {}).get("name", ""),
                metadata.get("uuid", ""),
                metadata.get("creation_time", ""),
                json.dumps(point, ensure_ascii=False, sort_keys=True),
            ])
    print(f"Exported {len(recovery_points)} recovery points to {args.csv}")


if __name__ == "__main__":
    main()
