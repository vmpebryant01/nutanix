#!/usr/bin/env bash
# cleanup_old_snapshots.sh
# Author: Paul Bryant
#
# Snapshot deletion is disabled until this script has a version-specific,
# tested way to enumerate snapshot IDs and creation times. Parsing NCLI
# human-readable output is not safe for unattended deletion.

set -euo pipefail
printf '%s\n' 'Snapshot cleanup is unavailable. Use a tested Prism Element API workflow for your cluster release.' >&2
exit 2
