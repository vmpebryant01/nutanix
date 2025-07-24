#!/bin/bash
# bulk_vm_snapshot_report.sh
# Author: Paul Bryant
#
# Purpose: Snapshot all VMs in a cluster, log per-VM success/failure, and export a CSV report.
#
# Usage:
#   ./bulk_vm_snapshot_report.sh <cluster_ip> <output_report.csv>
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <output_report.csv>"
  exit 1
fi

CLUSTER_IP="$1"
OUTCSV="$2"

echo "VMName,Result,Timestamp" > "$OUTCSV"
for VM in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list" | awk '/name:/ {print $2}'); do
  SNAPNAME="AutoSnapshot_${VM}_$(date +%Y%m%d%H%M)"
  if ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm snapshot-create vm-name=\"$VM\" snapshot-name=\"$SNAPNAME\""; then
    RESULT="SUCCESS"
  else
    RESULT="FAILURE"
  fi
  echo "$VM,$RESULT,$(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTCSV"
done
