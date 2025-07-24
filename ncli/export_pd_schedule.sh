#!/bin/bash
# export_pd_schedule.sh
# Author: Paul Bryant
#
# Purpose: List all PD (protection domain) schedules.
#
# Usage:
#   ./export_pd_schedule.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli pd schedule-list'
