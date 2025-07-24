#!/bin/bash
# list_host_details.sh
# Author: Paul Bryant
#
# Purpose: List details of all hosts in the cluster.
#
# Usage:
#   ./list_host_details.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli host list"
