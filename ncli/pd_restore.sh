#!/usr/bin/env bash
# pd_restore.sh
# Author: Paul Bryant
# Preview is the default. Restoring a protection domain changes VM data.

set -euo pipefail

if [[ $# -lt 3 || $# -gt 4 || ( $# -eq 4 && $4 != --apply ) ]]; then
  printf 'Usage: %s <cluster_host> <pd_name> <snapshot_id> [--apply]\n' "$0" >&2
  exit 2
fi
cluster_host=$1
pd_name=$2
snapshot_id=$3
if [[ ! $cluster_host =~ ^[A-Za-z0-9.-]+$ || ! $pd_name =~ ^[A-Za-z0-9._-]+$ || ! $snapshot_id =~ ^[A-Za-z0-9._-]+$ ]]; then
  printf 'Cluster host, protection domain, or snapshot ID contains unsupported characters.\n' >&2
  exit 2
fi
printf 'Restore protection domain %s to snapshot %s on %s\n' "$pd_name" "$snapshot_id" "$cluster_host"
if [[ ${4:-} != --apply ]]; then
  printf 'Preview only. Rerun with --apply to restore.\n'
  exit 0
fi
ssh -o BatchMode=yes "nutanix@$cluster_host" "ncli pd restore name=$pd_name snapshot-id=$snapshot_id"
