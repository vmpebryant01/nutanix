#!/bin/bash
# cleanup_old_snapshots_audit.sh
# Author: Paul Bryant
#
# Purpose: Find and (optionally) delete VM snapshots older than N days. Dry-run and audit log included.
#
# Usage:
#   ./cleanup_old_snapshots_audit.sh <cluster_ip> <days> [delete]
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <days> [delete]"
  exit 1
fi

CLUSTER_IP="$1"
DAYS="$2"
ACTION="$3"
LOG="old_snapshots_audit_$(date +%Y%m%d%H%M).log"

for VM in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list" | awk '/name:/ {print $2}'); do
  echo "Checking VM: $VM" | tee -a "$LOG"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm snapshot-list vm-name=\"$VM\"" | awk -v VM="$VM" -v DAYS="$DAYS" -F ' ' '
    /name:/ {snap=$2}
    /created-time:/ {
      # Convert to epoch seconds for age check
      cmd = "date -d \"" $2 "\" +%s"
      cmd | getline snap_time
      close(cmd)
      now = systime()
      age = int((now - snap_time) / 86400)
      if (age > DAYS) {
        print VM "," snap "," age
      }
    }
  ' >> "$LOG"
done

if [[ "$ACTION" == "delete" ]]; then
  while IFS=, read -r VM SNAP AGE; do
    [[ "$VM" == "VM" ]] && continue
    echo "Deleting snapshot $SNAP for VM $VM (age: $AGE days)" | tee -a "$LOG"
    ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm snapshot-delete snapshot-name=\"$SNAP\" vm-name=\"$VM\""
  done < <(grep -v '^Checking' "$LOG")
else
  echo "Dry run complete. To delete old snapshots, re-run with 'delete' as third argument."
fi
