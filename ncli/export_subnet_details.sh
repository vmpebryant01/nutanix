#!/bin/bash
# export_subnet_details.sh
# Author: Paul Bryant
#
# Purpose: Export details for all subnets.
#
# Usage:
#   ./export_subnet_details.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

for SUBNET in $(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli subnet list" | awk '/name:/ {print $2}'); do
  echo "[$(date)] Subnet: $SUBNET"
  ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli subnet get name=\"$SUBNET\""
done
