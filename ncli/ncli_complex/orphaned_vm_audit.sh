#!/bin/bash
# orphaned_vm_audit.sh
# Author: Paul Bryant
#
# Purpose: Find all powered-off or unprotected VMs and generate a detailed orphaned VM report.
#
# Usage:
#   ./orphaned_vm_audit.sh <cluster_ip> <output_report.csv>
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <output_report.csv>"
  exit 1
fi

CLUSTER_IP="$1"
OUTCSV="$2"

echo "VMName,PowerState,ProtectionDomain,Timestamp" > "$OUTCSV"

for VM in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list" | awk '/name:/ {print $2}'); do
  POWER=$(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm get name=\"$VM\" | grep 'power state' | awk '{print $NF}'")
  PD=$(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm get name=\"$VM\" | grep 'protection domain' | awk '{print $NF}'")
  if [[ "$POWER" == "off" || "$PD" == "None" ]]; then
    echo "$VM,$POWER,$PD,$(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTCSV"
  fi
done

echo "Orphaned VM audit complete. See $OUTCSV."
