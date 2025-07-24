#!/bin/bash
# list_storage.sh
# Author: Paul Bryant
#
# Purpose: Show cluster storage summary and all containers.
#
# Usage:
#   ./list_storage.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli cluster get-storage-summary'
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli container list'
