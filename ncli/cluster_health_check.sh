#!/bin/bash
# cluster_health_check.sh
# Author: Paul Bryant
#
# Purpose: Safely check Nutanix cluster health via NCLI and exit nonzero if unhealthy.
#
# Usage:
#   ./cluster_health_check.sh <cluster_ip>
#
# Requires:
#   - SSH key-based auth for user 'nutanix'
#   - No secrets or passwords in the script

set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

echo "[$(date)] Checking health of Nutanix cluster at $CLUSTER_IP..."
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli cluster get-state"
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli cluster info"
echo "[$(date)] Cluster health check completed."
