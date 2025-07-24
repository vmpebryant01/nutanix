#!/bin/bash
# dr_snapshot.sh
# Author: Paul Bryant
#
# Purpose: Create snapshots for a list of VMs before DR event.
#
# Usage:
#   ./dr_snapshot.sh <cluster_ip> <vm_list.txt>
#
# vm_list.txt = one VMName per line, no header

set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <vm_list.txt>"
  exit 1
fi

CLUSTER_IP="$1"
LIST="$2"

for VMNAME in $(cat "$LIST"); do
  echo "[$(date)] DR snapshot for $VMNAME..."
  SNAPNAME="DRTest_${VMNAME}_$(date +%Y%m%d%H%M)"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" \
    "ncli vm snapshot-create vm-name=\"$VMNAME\" snapshot-name=\"$SNAPNAME\""
done
