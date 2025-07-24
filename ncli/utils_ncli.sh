#!/bin/bash
# utils_ncli.sh - Shared helpers for NCLI automation
# Author: Paul Bryant

# Set -e means abort on any error; recommended for safety
set -e

# Safe NCLI SSH wrapper
ncli_ssh() {
  # Usage: ncli_ssh <cluster_ip> <ncli_command>
  local cluster_ip="$1"
  shift
  ssh -o BatchMode=yes -o StrictHostKeyChecking=no nutanix@"$cluster_ip" "$@"
}

# Log with timestamp
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

# Error out with message
fail() {
  log "ERROR: $*"
  exit 1
}

# Usage: check_cluster_health <cluster_ip>
check_cluster_health() {
  ncli_ssh "$1" "ncli cluster info" || fail "Cluster health check failed on $1"
}

export -f ncli_ssh log fail check_cluster_health
