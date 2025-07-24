#!/bin/bash
# export_vlan_subnet.sh
# Author: Paul Bryant
#
# Purpose: List all VLANs and subnets.
#
# Usage:
#   ./export_vlan_subnet.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli vlan list'
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli subnet list'
