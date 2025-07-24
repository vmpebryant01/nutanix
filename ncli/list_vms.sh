#!/bin/bash
# list_vms.sh
# Author: Paul Bryant
#
# Purpose: List all VMs on a Nutanix cluster.
#
# Usage:
#   ./list_vms.sh <cluster_ip>
#
# Requires:
#   - SSH key-based auth

set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

echo "[$(date)] Listing all VMs on cluster $CLUSTER_IP..."
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list"
