# Nutanix AHV Automation Scripts

Author: Paul Bryant

This repository contains six runnable Python scripts plus a shared client, 42 Ansible playbooks, and NCLI shell examples. They are examples for Prism Central and Prism Element environments. API coverage and payloads vary by product version. Test each workflow on a nonproduction system before using it to change infrastructure.

## Start here

| Example | What it does | Safety and verification |
| --- | --- | --- |
| [VM inventory export](python/export_vm_inventory.py) | Exports Prism Central v3 VM inventory to CSV | Read-only workflow; shared pagination behavior has unit tests. |
| [Bulk power control](python/bulk_vm_power.py) | Previews or requests VM ON and OFF changes from CSV | Preview by default; validates actions and preserves the existing VM specification. Planning logic has unit tests. |
| [Bulk category assignment](python/bulk_category_assign.py) | Previews or adds category values to VMs from CSV | Preview by default; validates input and preserves existing category values. Planning logic has unit tests. |

See [script status](docs/script_status.md) and [workflow notes](docs/workflows.md) for the scope of those checks. No live Prism or AHV environment was available for validation.

## Python setup

Install Python 3.11 or later, then run `python -m pip install -r requirements.txt`. Copy `.env.example` to `.env` and supply your Prism Central address and credentials. The Python client verifies TLS certificates. Set `PRISM_CA_BUNDLE` if your internal CA is not in the system trust store.

Read-only inventory and alert exports use the paginated Prism Central v3 list API. Bulk category assignment and VM power changes print a preview by default and require `--apply`. The power script supports ON and OFF through a VM GET and PUT. A successful API response means that Prism accepted a task; check the task outcome in Prism before treating the change as complete.

`python/export_snapshots.py` stops with an explanation because its former snapshot listing endpoint was not verified. `python/export_recovery_points.py` exports Prism Central recovery points, including each raw record. Prism Central recovery points and Prism Element snapshots are different resources. Validate the recovery point response against your release before relying on that export.

## Ansible setup

From `ansible/`, install `community.general` with `ansible-galaxy collection install -r requirements.yml`. Update `inventory/hosts.ini`. Copy `.env.ansible_vault.example` to `.env.ansible_vault` and `.env.dr_vault.example` to `.env.dr_vault`, set real values, and encrypt both files with `ansible-vault encrypt`. Populate the CSV files in `csv_samples/` before running the related playbooks. API playbooks execute from the controller and validate TLS certificates.

The snapshot and DR roles require explicit confirmation variables. Their action endpoints still need validation against the Prism release and cluster configuration in use. The CSV samples contain headers only so no VM can be targeted accidentally.

## NCLI scripts

The NCLI shell scripts are examples. Review their SSH target, parsing, and command effects before use. Both snapshot cleanup scripts exit without deleting anything until a version-specific, tested snapshot workflow is available. The bulk power and protection domain restore scripts preview by default and require `--apply`.

Static checks and a small Python unit test suite are provided. No live Prism or AHV environment was available for this repository.

## Use and contributions

Copyright (c) 2025-2026 Paul Bryant. All rights reserved. No permission to copy, modify, or redistribute the code is granted by this repository. See [copyright and reuse](COPYRIGHT.md).

See [contributing](CONTRIBUTING.md) and [security reporting](SECURITY.md) before opening an issue or pull request.
