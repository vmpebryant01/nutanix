#!/bin/bash
# export_vm_categories.sh
# Author: Paul Bryant
#
# Purpose: Export all VM categories for all VMs.
#
# Usage:
#   ./export_vm_categories.sh <cluster_ip> > vm_categories.txt
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli vm list show-categories=true'
