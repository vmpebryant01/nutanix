#!/bin/bash
# export_category_assignments.sh
# Author: Paul Bryant
#
# Purpose: Export all objects assigned to a given category.
#
# Usage:
#   ./export_category_assignments.sh <cluster_ip> <category_name>
#
set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <category_name>"
  exit 1
fi

CLUSTER_IP="$1"
CATNAME="$2"

ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli category get name=\"$CATNAME\""
