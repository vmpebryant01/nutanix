#!/bin/bash
# export_pd_restore_points.sh
# Author: Paul Bryant
#
# Purpose: List all available restore points for each protection domain (PD).
#
# Usage:
#   ./export_pd_restore_points.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

for PD in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli pd list" | awk '/name:/ {print $2}'); do
  echo "[$(date)] PD: $PD"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli pd snapshot-list name=\"$PD\""
done
