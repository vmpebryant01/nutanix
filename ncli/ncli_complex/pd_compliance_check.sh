#!/bin/bash
# pd_compliance_check.sh
# Author: Paul Bryant
#
# Purpose: Ensure all critical VMs are assigned to a protection domain. Alert if any are missing.
#
# Usage:
#   ./pd_compliance_check.sh <cluster_ip> <critical_vms.csv> <alert_email>
#
# critical_vms.csv: one VM name per line (no header)
#
set -e

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  echo "Usage: $0 <cluster_ip> <critical_vms.csv> <alert_email>"
  exit 1
fi

CLUSTER_IP="$1"
CSV="$2"
EMAIL="$3"
MISSING=()

for VM in $(cat "$CSV"); do
  PDINFO=$(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli vm get name=\"$VM\" | grep 'protection domain'")
  if [[ -z "$PDINFO" || "$PDINFO" == *"None"* ]]; then
    MISSING+=("$VM")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo -e "The following critical VMs are NOT protected by a protection domain on $CLUSTER_IP:\n${MISSING[*]}" | mail -s "Nutanix PD Compliance Alert" "$EMAIL"
  echo "Compliance failure: notification sent."
else
  echo "All critical VMs are protected."
fi
