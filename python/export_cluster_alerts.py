#!/usr/bin/env python3
"""
export_cluster_alerts.py
Author: Paul Bryant

Purpose:
    Export all active cluster alerts for audit/compliance.
Usage:
    python export_cluster_alerts.py --env .env --csv csv_samples/cluster_alerts.csv

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

def fetch_alerts():
    url = f"https://{PRISM}:9440/api/nutanix/v3/alerts/list"
    body = {"kind": "alert", "length": 500}
    r = session.post(url, json=body)
    return r.json().get("entities", []) if r.ok else []

with open(args.csv, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["AlertName", "Severity", "Entity", "Created", "Status", "UUID"])
    for alert in fetch_alerts():
        name = alert["spec"]["name"]
        severity = alert["status"].get("severity", "Unknown")
        entity = alert["spec"]["resources"].get("entity_reference", {}).get("name", "Unknown")
        created = alert["metadata"].get("creation_time", "Unknown")
        status = alert["status"].get("state", "Unknown")
        uuid = alert["metadata"]["uuid"]
        writer.writerow([name, severity, entity, created, status, uuid])

print(f"Cluster alerts exported to {args.csv}")
