#!/usr/bin/env bash
# cleanup_old_snapshots_audit.sh
# Author: Paul Bryant
#
# Deletion is disabled until a version-specific snapshot inventory and
# age calculation can be verified against Prism Element.

set -euo pipefail
printf '%s\n' 'Snapshot cleanup is unavailable. Use a tested Prism Element API workflow for your cluster release.' >&2
exit 2
