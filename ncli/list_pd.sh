#!/bin/bash
# list_pd.sh
# Author: Paul Bryant
#
# Purpose: List all protection domains.
#
# Usage:
#   ./list_pd.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli pd list'
