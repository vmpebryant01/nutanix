#!/usr/bin/env bash
# bulk_power_control.sh
# Author: Paul Bryant
# CSV columns: VMName,Action. Preview is the default.

set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 || ( $# -eq 3 && $3 != --apply ) ]]; then
  printf 'Usage: %s <cluster_host> <vm_power.csv> [--apply]\n' "$0" >&2
  exit 2
fi
cluster_host=$1
csv=$2
if [[ ! $cluster_host =~ ^[A-Za-z0-9.-]+$ || ! -r $csv ]]; then
  printf 'Invalid cluster host or unreadable CSV file.\n' >&2
  exit 2
fi

names=()
actions=()
while IFS=, read -r vm_name action extra || [[ -n ${vm_name:-} ]]; do
  action=${action%$'\r'}
  if [[ $vm_name == VMName && $action == Action ]]; then
    continue
  fi
  if [[ -n ${extra:-} || ! $vm_name =~ ^[A-Za-z0-9._-]+$ || ! $action =~ ^(ON|OFF)$ ]]; then
    printf 'Invalid VM name or action in CSV: %s,%s\n' "$vm_name" "$action" >&2
    exit 2
  fi
  names+=("$vm_name")
  actions+=("$action")
done < "$csv"

if (( ${#names[@]} == 0 )); then
  printf 'CSV has no power actions.\n' >&2
  exit 2
fi
for index in "${!names[@]}"; do
  printf '%s: %s\n' "${names[index]}" "${actions[index]}"
done
if [[ ${3:-} != --apply ]]; then
  printf 'Preview only. Rerun with --apply to change power state.\n'
  exit 0
fi

for index in "${!names[@]}"; do
  vm_name=${names[index]}
  case ${actions[index]} in
    ON) command='power-on' ;;
    OFF) command='power-off' ;;
  esac
  ssh -o BatchMode=yes "nutanix@$cluster_host" "ncli vm $command name=$vm_name"
done
