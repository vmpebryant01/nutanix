#!/bin/bash
# orphaned_vm_report.sh
# Author: Paul Bryant
#
# Purpose: Report all powered-off and unprotected VMs (potential orphans).
#
# Usage:
#   ./orphaned_vm_report.sh <cluster_ip>
#
# Requires:
#   - SSH key-based auth

set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

echo "[$(date)] Listing all powered-off VMs (possible orphans)..."
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list power-state=off"

echo "[$(date)] Listing all unprotected VMs (not in a protection domain)..."
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list protection-domain=false"
