#!/bin/bash
# cluster_health_audit_notify.sh
# Author: Paul Bryant
#
# Purpose: Run full cluster health and alert audit. If critical issues are found, notify admins via email.
#
# Usage:
#   ./cluster_health_audit_notify.sh <cluster_ip> <alert_email>
#
# Requires:
#   - Mail utility configured on host
#   - SSH key-based auth

set -e

if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <cluster_ip> <alert_email>"
  exit 1
fi

CLUSTER_IP="$1"
EMAIL="$2"
TMP_REPORT="/tmp/cluster_health_report_$$.txt"
CRIT_FOUND=0

echo "[$(date)] Running health check on $CLUSTER_IP..." > "$TMP_REPORT"
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli cluster get-state" >> "$TMP_REPORT"
ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli cluster info" >> "$TMP_REPORT"

# Find critical alerts
echo -e "\nCluster Alerts:" >> "$TMP_REPORT"
ALERTS=$(ssh -o BatchMode=yes nutanix@"$CLUSTER_IP" "ncli alert ls | grep -i CRITICAL")
echo "$ALERTS" >> "$TMP_REPORT"

if [[ -n "$ALERTS" ]]; then
  CRIT_FOUND=1
  echo -e "\nCritical alert(s) detected. Sending email notification."
  mail -s "Nutanix Cluster Critical Alerts on $CLUSTER_IP" "$EMAIL" < "$TMP_REPORT"
fi

if [[ $CRIT_FOUND -eq 0 ]]; then
  echo "No critical alerts detected."
fi

rm -f "$TMP_REPORT"
