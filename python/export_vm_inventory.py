#!/usr/bin/env python3
"""
export_vm_inventory.py
Author: Paul Bryant

Purpose:
    Export all VM inventory (name, UUID, power state, categories) to CSV from Nutanix Prism Central.
Usage:
    python export_vm_inventory.py --env .env --csv csv_samples/vm_inventory_report.csv

Requirements:
    pip install requests python-dotenv
"""

import os, csv, argparse, requests
from dotenv import load_dotenv

parser = argparse.ArgumentParser()
parser.add_argument("--env", default=".env", help="Environment file with Prism creds")
parser.add_argument("--csv", required=True, help="CSV output file")
args = parser.parse_args()

load_dotenv(args.env)
PRISM = os.getenv("PRISM_CENTRAL")
USER = os.getenv("PRISM_USER")
PASS = os.getenv("PRISM_PASS")

session = requests.Session()
session.auth = (USER, PASS)
session.verify = False
session.headers.update({"Content-Type": "application/json"})

def fetch_vms():
    url = f"https://{PRISM}:9440/api/nutanix/v3/vms/list"
    body = {"kind": "vm", "length": 500}
    r = session.post(url, json=body)
    return r.json().get("entities", []) if r.ok else []

with open(args.csv, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["VMName", "UUID", "PowerState", "Categories"])
    for vm in fetch_vms():
        name = vm["spec"]["name"]
        uuid = vm["metadata"]["uuid"]
        state = vm["status"].get("power_state", "Unknown")
        categories = ",".join(vm["metadata"].get("categories_mapping", {}).keys())
        writer.writerow([name, uuid, state, categories])

print(f"VM inventory exported to {args.csv}")
