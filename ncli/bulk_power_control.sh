#!/bin/bash
# bulk_power_control.sh
# Author: Paul Bryant
#
# Purpose: Power ON, OFF, or RESET VMs in bulk from a CSV.
#
# Usage:
#   ./bulk_power_control.sh <cluster_ip> <vm_power.csv>
#
# CSV Format: VMName,Action
#   (e.g., "AppServer01,ON")
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <vm_power.csv>"
  exit 1
fi

CLUSTER_IP="$1"
CSV="$2"

while IFS=, read -r VMNAME ACTION; do
  [[ "$VMNAME" == "VMName" ]] && continue
  echo "[$(date)] Setting power $ACTION for $VMNAME..."
  case "$ACTION" in
    ON)    CMD="ncli vm power-on name=\"$VMNAME\"" ;;
    OFF)   CMD="ncli vm power-off name=\"$VMNAME\"" ;;
    RESET) CMD="ncli vm reset name=\"$VMNAME\"" ;;
    *)     echo "Invalid action $ACTION for $VMNAME"; continue ;;
  esac
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "$CMD" || echo "Failed for $VMNAME"
done < "$CSV"
