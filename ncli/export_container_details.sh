#!/bin/bash
# export_container_details.sh
# Author: Paul Bryant
#
# Purpose: Export details for all containers.
#
# Usage:
#   ./export_container_details.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

for CONT in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli container list" | awk '/name:/ {print $2}'); do
  echo "[$(date)] Container: $CONT"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli container get name=\"$CONT\""
done
