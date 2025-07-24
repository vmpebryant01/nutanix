#!/bin/bash
# export_cluster_version.sh
# Author: Paul Bryant
#
# Purpose: Show Nutanix cluster version.
#
# Usage:
#   ./export_cluster_version.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli cluster version'
