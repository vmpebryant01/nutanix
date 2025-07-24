#!/bin/bash
# export_vm_nics.sh
# Author: Paul Bryant
#
# Purpose: Export NIC info for all VMs on a cluster.
#
# Usage:
#   ./export_vm_nics.sh <cluster_ip> > vm_nics_report.txt
#
set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 <cluster_ip>"
  exit 1
fi

CLUSTER_IP="$1"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" 'ncli vm list columns=name,uuid,nics'
