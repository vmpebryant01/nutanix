#!/usr/bin/env python3
"""
orphaned_vm_audit.py
Author: Paul Bryant

Purpose:
    Identify VMs that are powered off, have no categories, or are not in a protection domain.
Usage:
    python orphaned_vm_audit.py --env .env --csv csv_samples/orphaned_vms_report.csv

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

def fetch_vms():
    url = f"https://{PRISM}:9440/api/nutanix/v3/vms/list"
    body = {"kind": "vm", "length": 500}
    r = session.post(url, json=body)
    return r.json().get("entities", []) if r.ok else []

with open(args.csv, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["VMName", "UUID", "PowerState", "Categories", "ProtectionDomain"])
    for vm in fetch_vms():
        name = vm["spec"]["name"]
        uuid = vm["metadata"]["uuid"]
        state = vm["status"].get("power_state", "Unknown")
        cats = ",".join(vm["metadata"].get("categories_mapping", {}).keys())
        pd = vm["status"].get("protection_domain", "None")
        if state == "OFF" or not cats or pd == "None":
            writer.writerow([name, uuid, state, cats, pd])

print(f"Orphaned VM audit exported to {args.csv}")
