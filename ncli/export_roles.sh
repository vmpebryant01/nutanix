#!/bin/bash
# export_roles.sh
# Author: Paul Bryant
#
# Purpose: Export all user roles.
#
# Usage:
#   ./export_roles.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli role list'
