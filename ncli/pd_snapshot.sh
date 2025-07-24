#!/bin/bash
# pd_snapshot.sh
# Author: Paul Bryant
#
# Purpose: Snapshot a protection domain (PD) for DR or compliance.
#
# Usage:
#   ./pd_snapshot.sh <cluster_ip> <pd_name>
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <pd_name>"
  exit 1
fi

CLUSTER_IP="$1"
PDNAME="$2"

SNAPNAME="PD_DR_$(date +%Y%m%d%H%M)"
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" \
  "ncli pd snapshot-create name=\"$PDNAME\" snapshot-name=\"$SNAPNAME\""
