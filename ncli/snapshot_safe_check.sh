#!/bin/bash
# snapshot_safe_check.sh
# Author: Paul Bryant
#
# Purpose: Safely snapshot a VM if the cluster is healthy.
#
# Usage:
#   ./snapshot_safe_check.sh <cluster_ip> <vm_name>
#
# Requires:
#   - SSH key-based auth

set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <vm_name>"
  exit 1
fi

CLUSTER_IP="$1"
VMNAME="$2"

echo "[$(date)] Checking cluster health on $CLUSTER_IP..."
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli cluster get-state | grep 'state: Normal'"
if [[ $? -ne 0 ]]; then
  echo "[$(date)] ERROR: Cluster not healthy, aborting snapshot."
  exit 2
fi

SNAPNAME="SafeBackup_${VMNAME}_$(date +%Y%m%d%H%M)"
echo "[$(date)] Creating snapshot $SNAPNAME for VM $VMNAME..."
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" \
  "ncli vm snapshot-create vm-name=\"$VMNAME\" snapshot-name=\"$SNAPNAME\""

echo "[$(date)] Snapshot operation completed."
