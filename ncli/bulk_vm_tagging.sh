#!/bin/bash
# bulk_vm_tagging.sh
# Author: Paul Bryant
#
# Purpose: Assign multiple tags (categories) to VMs using a CSV.
#
# Usage:
#   ./bulk_vm_tagging.sh <cluster_ip> <tags.csv>
#
# CSV Format: VMName,Tag1,Tag2,Tag3...
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <tags.csv>"
  exit 1
fi

CLUSTER_IP="$1"
CSV="$2"

while IFS=, read -r VMNAME TAGS; do
  [[ "$VMNAME" == "VMName" ]] && continue
  TAGLIST=$(echo "$TAGS" | tr ',' ' ')
  echo "[$(date)] Assigning tags $TAGLIST to $VMNAME"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm update name=\"$VMNAME\" categories=\"$TAGLIST\""
done < "$CSV"
