# Nutanix AHV Automation Suite

This repository contains 30+ automation scripts for each of Python, Ansible, and NCLI, each designed for safe, bulk, and repeatable management of Nutanix AHV clusters.

**Key Features:**
- Bulk microsegmentation, tagging, DR runbook, inventory, CMDB sync, compliance, and more
- All automation is API-driven, CSV-fed, and consultative in design
- Author for all sample data: Paul Bryant

## Structure

- `python/` — 30 Python scripts
- `ansible/playbooks/` — 30 Ansible playbooks
- `ncli/` — 30 NCLI shell scripts
- `csv_samples/` — Sample input files for each workflow (20 rows each)
- `.env.example` — Example environment config for Prism, CMDB, SSH
- `automation_best_practices.md` — Standards for safe automation
- `dashboard/` — Sample dashboard output templates

## Getting Started

1. Copy `.env.example` to `.env` and update with your environment.
2. Review the CSV samples in `csv_samples/`.
3. Run scripts from their respective directories.
4. See `automation_best_practices.md` for safety, logging, rollback, and dry-run guidance.
