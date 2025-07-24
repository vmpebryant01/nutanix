#!/bin/bash
# export_alerts.sh
# Author: Paul Bryant
#
# Purpose: Export all current cluster alerts.
#
# Usage:
#   ./export_alerts.sh <cluster_ip> > alerts_report.txt
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli alert ls'
