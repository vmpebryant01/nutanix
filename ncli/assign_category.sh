#!/bin/bash
# assign_category.sh
# Author: Paul Bryant
#
# Purpose: Assign Nutanix categories to VMs in bulk from CSV.
#
# Usage:
#   ./assign_category.sh <cluster_ip> <categories.csv>
#
# CSV Format: VMName,Category
#   (with header row; e.g., "VM01,Production")
#
# Requires:
#   - SSH key-based auth

set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <categories.csv>"
  exit 1
fi

CLUSTER_IP="$1"
CSV_FILE="$2"

while IFS=, read -r VMNAME CATEGORY; do
  [[ "$VMNAME" == "VMName" ]] && continue # Skip header
  echo "[$(date)] Assigning category '$CATEGORY' to VM '$VMNAME'..."
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" \
    "ncli vm update name=\"$VMNAME\" categories=\"$CATEGORY\"" || \
    echo "[$(date)] ERROR: Failed to assign category for $VMNAME"
done < "$CSV_FILE"

echo "[$(date)] Bulk category assignment completed."
