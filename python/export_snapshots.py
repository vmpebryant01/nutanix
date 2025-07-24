#!/usr/bin/env python3
"""
export_snapshots.py
Author: Paul Bryant

Purpose:
    Export a report of all VM snapshots and their creation time.
Usage:
    python export_snapshots.py --env .env --csv csv_samples/snapshot_report.csv

Requirements:
    pip install requests python-dotenv
"""

import os, csv, argparse, requests
from dotenv import load_dotenv

parser = argparse.ArgumentParser()
parser.add_argument("--env", default=".env")
parser.add_argument("--csv", required=True)
args = parser.parse_args()

load_dotenv(args.env)
PRISM = os.getenv("PRISM_CENTRAL")
USER = os.getenv("PRISM_USER")
PASS = os.getenv("PRISM_PASS")

session = requests.Session()
session.auth = (USER, PASS)
session.verify = False
session.headers.update({"Content-Type": "application/json"})

def fetch_snapshots():
    url = f"https://{PRISM}:9440/api/nutanix/v3/snapshots/list"
    body = {"kind": "snapshot", "length": 500}
    r = session.post(url, json=body)
    return r.json().get("entities", []) if r.ok else []

with open(args.csv, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["SnapshotName", "VMName", "Created", "UUID"])
    for snap in fetch_snapshots():
        name = snap["spec"]["name"]
        uuid = snap["metadata"]["uuid"]
        created = snap["metadata"].get("creation_time", "Unknown")
        vm_name = snap["spec"]["resources"].get("vm_reference", {}).get("name", "Unknown")
        writer.writerow([name, vm_name, created, uuid])

print(f"Snapshot report exported to {args.csv}")
