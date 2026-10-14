"""Export Prism Central v3 alerts to CSV.

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
        alerts = list(client.list_entities("alert"))

    with open(args.csv, "w", newline="", encoding="utf-8") as stream:
        writer = csv.writer(stream)
        writer.writerow(["AlertName", "Severity", "Entity", "Created", "Status", "UUID"])
        for alert in alerts:
            spec = alert.get("spec", {})
            status = alert.get("status", {})
            metadata = alert.get("metadata", {})
            entity = spec.get("resources", {}).get("entity_reference", {})
            writer.writerow([
                spec.get("name", ""),
                status.get("severity", ""),
                entity.get("name", ""),
                metadata.get("creation_time", ""),
                status.get("state", ""),
                metadata.get("uuid", ""),
            ])
    print(f"Exported {len(alerts)} alerts to {args.csv}")


if __name__ == "__main__":
    main()
