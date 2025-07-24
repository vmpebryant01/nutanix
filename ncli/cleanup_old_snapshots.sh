#!/bin/bash
# cleanup_old_snapshots.sh
# Author: Paul Bryant
#
# Purpose: Delete snapshots older than a specified number of days.
#
# Usage:
#   ./cleanup_old_snapshots.sh <cluster_ip> <days>
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <days>"
  exit 1
fi

CLUSTER_IP="$1"
DAYS="$2"

for VM in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list" | awk '/name:/ {print $2}'); do
  echo "[$(date)] Processing VM: $VM"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm snapshot-list vm-name=\"$VM\"" | \
    awk -v DAYS="$DAYS" -v VM="$VM" -F ' ' '/name:/ {SN=$2} /created-time:/ {DT=$2; if ((systime()-mktime(substr(DT,1,4)" "substr(DT,6,2)" "substr(DT,9,2)" "substr(DT,12,2)" "substr(DT,15,2)" "substr(DT,18,2))) > (DAYS*86400)) print SN;}' | \
    while read SNAP; do
      [ -n "$SNAP" ] && ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm snapshot-delete snapshot-name=\"$SNAP\" vm-name=\"$VM\""
    done
done
