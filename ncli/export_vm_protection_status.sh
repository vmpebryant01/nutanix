#!/bin/bash
# export_vm_protection_status.sh
# Author: Paul Bryant
#
# Purpose: List protection domain membership for all VMs.
#
# Usage:
#   ./export_vm_protection_status.sh <cluster_ip>
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm list show-protection-domain=true"
