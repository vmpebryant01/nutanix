#!/usr/bin/env python3
"""
bulk_category_assign.py
Author: Paul Bryant

Purpose:
    Bulk assign categories (tags) to VMs on Nutanix Prism Central from a CSV file.
    Each row should have VMName and Category columns.

Usage:
    python bulk_category_assign.py --csv csv_samples/vm_category_assignment.csv --env .env

CSV Format:
    VMName,Category
    AppServer01,Production
    DBServer01,Finance
    ...

Requirements:
    pip install requests python-dotenv
    (Set .env with PRISM_CENTRAL, PRISM_USER, PRISM_PASS)
"""

import os
import csv
import argparse
import requests
import logging
from dotenv import load_dotenv

# Setup argparse
parser = argparse.ArgumentParser(description="Bulk assign Nutanix categories to VMs from CSV")
parser.add_argument("--csv", required=True, help="CSV file with VMName,Category columns")
parser.add_argument("--env", default=".env", help="Environment file with Prism creds")
parser.add_argument("--dryrun", action="store_true", help="Show actions without changing anything")
args = parser.parse_args()

# Load .env
load_dotenv(args.env)
PRISM = os.getenv("PRISM_CENTRAL")
USER = os.getenv("PRISM_USER")
PASS = os.getenv("PRISM_PASS")

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')

if not all([PRISM, USER, PASS]):
    logging.error("Missing required environment variables. Check .env file.")
    exit(1)

session = requests.Session()
session.auth = (USER, PASS)
session.verify = False
session.headers.update({"Content-Type": "application/json"})

def find_vm_uuid(vm_name):
    url = f"https://{PRISM}:9440/api/nutanix/v3/vms/list"
    body = {"kind": "vm", "filter": f"vm_name=={vm_name}"}
    r = session.post(url, json=body)
    if r.ok and r.json().get("entities"):
        return r.json()["entities"][0]["metadata"]["uuid"]
    return None

def assign_category(vm_uuid, category):
    url = f"https://{PRISM}:9440/api/nutanix/v3/vms/{vm_uuid}/categories/{category}"
    r = session.post(url, json={})
    return r.status_code in (200, 201)

with open(args.csv, newline='') as f:
    reader = csv.DictReader(f)
    for row in reader:
        vm_name = row["VMName"].strip()
        category = row["Category"].strip()
        if not vm_name or not category:
            logging.warning(f"Skipping row with missing VMName or Category: {row}")
            continue

        logging.info(f"Processing VM '{vm_name}' for category '{category}'")
        uuid = find_vm_uuid(vm_name)
        if not uuid:
            logging.error(f"VM '{vm_name}' not found. Skipping.")
            continue

        if args.dryrun:
            logging.info(f"[DRY RUN] Would assign category '{category}' to VM '{vm_name}' (UUID: {uuid})")
        else:
            if assign_category(uuid, category):
                logging.info(f"Category '{category}' assigned to VM '{vm_name}'.")
            else:
                logging.error(f"Failed to assign category '{category}' to VM '{vm_name}'.")

logging.info("Bulk category assignment completed.")
