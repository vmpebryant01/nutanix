#!/bin/bash
# export_licenses.sh
# Author: Paul Bryant
#
# Purpose: Export all cluster license info for compliance/reporting.
#
# Usage:
#   ./export_licenses.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli license list'
