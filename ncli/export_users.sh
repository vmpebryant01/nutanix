#!/bin/bash
# export_users.sh
# Author: Paul Bryant
#
# Purpose: Export all user accounts on the cluster.
#
# Usage:
#   ./export_users.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli user list'
