#!/bin/bash
# pd_schedule_update.sh
# Author: Paul Bryant
#
# Purpose: Update schedule interval for a protection domain.
#
# Usage:
#   ./pd_schedule_update.sh <cluster_ip> <pd_name> <interval_minutes>
#
set -e

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "Usage: $0 <cluster_ip> <pd_name> <interval_minutes>"
  exit 1
fi

CLUSTER_IP="$1"
PDNAME="$2"
INTERVAL="$3"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli pd schedule-update name=\"$PDNAME\" interval=\"$INTERVAL\""
