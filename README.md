# Nutanix AHV Automation Scripts

Author: Paul Bryant

This repository contains six runnable Python scripts plus a shared client, 42 Ansible playbooks, and 35 NCLI shell scripts. They are examples for Prism Central and Prism Element environments. API coverage and payloads vary by product version. Test each workflow on a nonproduction system before using it to change infrastructure.

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
