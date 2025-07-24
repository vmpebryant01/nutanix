#!/bin/bash
# pd_restore.sh
# Author: Paul Bryant
#
# Purpose: Restore a PD to a given snapshot (restore point).
#
# Usage:
#   ./pd_restore.sh <cluster_ip> <pd_name> <snapshot_id>
#
set -e

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "Usage: $0 <cluster_ip> <pd_name> <snapshot_id>"
  exit 1
fi

CLUSTER_IP="$1"
PDNAME="$2"
SNAPID="$3"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli pd restore name=\"$PDNAME\" snapshot-id=\"$SNAPID\""
