#!/usr/bin/env python3
"""
bulk_vm_power.py
Author: Paul Bryant

Purpose:
    Bulk power on/off/reset VMs listed in a CSV using Prism Central API.
Usage:
    python bulk_vm_power.py --csv csv_samples/vm_power_actions.csv --env .env

CSV Format:
    VMName,Action  # (Action = ON, OFF, RESET)
"""

import os, csv, argparse, requests
from dotenv import load_dotenv

parser = argparse.ArgumentParser()
parser.add_argument("--csv", required=True, help="CSV file with VMName,Action")
parser.add_argument("--env", default=".env", help="Environment file")
parser.add_argument("--dryrun", action="store_true")
args = parser.parse_args()

load_dotenv(args.env)
PRISM = os.getenv("PRISM_CENTRAL")
USER = os.getenv("PRISM_USER")
PASS = os.getenv("PRISM_PASS")

session = requests.Session()
session.auth = (USER, PASS)
session.verify = False
session.headers.update({"Content-Type": "application/json"})

def find_vm_uuid(vm_name):
    url = f"https://{PRISM}:9440/api/nutanix/v3/vms/list"
    r = session.post(url, json={"kind": "vm", "filter": f"vm_name=={vm_name}"})
    if r.ok and r.json().get("entities"):
        return r.json()["entities"][0]["metadata"]["uuid"]
    return None

def power_vm(vm_uuid, action):
    url = f"https://{PRISM}:9440/api/nutanix/v3/vms/{vm_uuid}/set_power_state"
    body = {"transition": action}
    r = session.post(url, json=body)
    return r.status_code in (200, 202)

with open(args.csv, newline="") as f:
    for row in csv.DictReader(f):
        vm_name = row["VMName"].strip()
        action = row["Action"].strip().upper()
        if action not in ("ON", "OFF", "RESET"):
            print(f"Invalid action '{action}' for {vm_name}")
            continue
        uuid = find_vm_uuid(vm_name)
        if not uuid:
            print(f"VM '{vm_name}' not found.")
            continue
        if args.dryrun:
            print(f"[DRY RUN] Would set power {action} for VM '{vm_name}'")
        else:
            if power_vm(uuid, action):
                print(f"Power {action} for VM '{vm_name}': SUCCESS")
            else:
                print(f"Power {action} for VM '{vm_name}': FAILURE")
