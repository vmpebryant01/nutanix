# prism_vm_snapshot Role

Takes snapshots of VMs (CSV-driven) and renders a report.
- See `defaults/main.yml` for default vars.
- Input: `vm_list` (passed as extra_var or loaded in playbook).
- Output: Snapshot JSON report.
