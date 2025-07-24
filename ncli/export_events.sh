#!/bin/bash
# export_events.sh
# Author: Paul Bryant
#
# Purpose: Export cluster events for audit/troubleshooting.
#
# Usage:
#   ./export_events.sh <cluster_ip> > events_report.txt
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli event ls'
