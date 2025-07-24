#!/bin/bash
# export_pd_failover_targets.sh
# Author: Paul Bryant
#
# Purpose: List failover targets for each protection domain.
#
# Usage:
#   ./export_pd_failover_targets.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

for PD in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli pd list" | awk '/name:/ {print $2}'); do
  echo "[$(date)] PD: $PD"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli pd get name=\"$PD\" | grep -i failover"
done
