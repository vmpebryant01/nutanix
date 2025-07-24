#!/bin/bash
# export_vm_snapshots.sh
# Author: Paul Bryant
#
# Purpose: List all snapshots for every VM.
#
# Usage:
#   ./export_vm_snapshots.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

for VM in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list" | awk '/name:/ {print $2}'); do
  echo "[$(date)] VM: $VM"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm snapshot-list vm-name=\"$VM\""
done
