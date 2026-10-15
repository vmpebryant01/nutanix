# Script status

Author: Paul Bryant

No file below was validated against a live Prism Central, Prism Element, or AHV environment here. Python compilation, Ansible YAML parsing, and unit tests provide limited local evidence. The repository workflow also checks Bash syntax on Linux. Unit-tested means selected planning or client logic only; task completion and product-version compatibility remain unverified.

See [representative workflows](workflows.md) for selected examples. The Prism Central Python client uses the v3 API family; check each other workflow against the installed product release.

| File | Evidence and current limit |
| --- | --- |
| [`ansible/playbooks/api_health_check.yml`](../ansible/playbooks/api_health_check.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/bulk_microsegmentation.yml`](../ansible/playbooks/bulk_microsegmentation.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/bulk_tag_assignment.yml`](../ansible/playbooks/bulk_tag_assignment.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/category_assign.yml`](../ansible/playbooks/category_assign.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/cluster_alerts.yml`](../ansible/playbooks/cluster_alerts.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/cmdb_drift_report.yml`](../ansible/playbooks/cmdb_drift_report.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/cmdb_sync.yml`](../ansible/playbooks/cmdb_sync.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/custom_fields.yml`](../ansible/playbooks/custom_fields.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/dr_orchestration.yml`](../ansible/playbooks/dr_orchestration.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/dr_runbook.yml`](../ansible/playbooks/dr_runbook.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/export_categories.yml`](../ansible/playbooks/export_categories.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/export_nics.yml`](../ansible/playbooks/export_nics.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/external_backup_jobs.yml`](../ansible/playbooks/external_backup_jobs.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/ha_policy_report.yml`](../ansible/playbooks/ha_policy_report.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/host_inventory.yml`](../ansible/playbooks/host_inventory.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/license_inventory.yml`](../ansible/playbooks/license_inventory.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/log_export_map.yml`](../ansible/playbooks/log_export_map.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/monitoring_targets.yml`](../ansible/playbooks/monitoring_targets.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/network_policy_bulk.yml`](../ansible/playbooks/network_policy_bulk.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/orphaned_vm_report.yml`](../ansible/playbooks/orphaned_vm_report.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/pci_compliance_report.yml`](../ansible/playbooks/pci_compliance_report.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/app_onboarding.yml`](../ansible/playbooks/playbooks_complex/app_onboarding.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/blue_green_deploy.yml`](../ansible/playbooks/playbooks_complex/blue_green_deploy.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/compliance_scan_remediate.yml`](../ansible/playbooks/playbooks_complex/compliance_scan_remediate.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/crossplatform_inventory.yml`](../ansible/playbooks/playbooks_complex/crossplatform_inventory.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/dr_orchestration.yml`](../ansible/playbooks/playbooks_complex/dr_orchestration.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/patch_management.yml`](../ansible/playbooks/playbooks_complex/patch_management.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/scheduled_snapshot_validation.yml`](../ansible/playbooks/playbooks_complex/scheduled_snapshot_validation.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/security_drift_remediation.yml`](../ansible/playbooks/playbooks_complex/security_drift_remediation.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/self_service_vm_provision.yml`](../ansible/playbooks/playbooks_complex/self_service_vm_provision.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/playbooks_complex/Zero-Touch Tenant Offboarding and Resource Cleanup.yml`](../ansible/playbooks/playbooks_complex/Zero-Touch Tenant Offboarding and Resource Cleanup.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/prism_user_map.yml`](../ansible/playbooks/prism_user_map.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/project_mappings.yml`](../ansible/playbooks/project_mappings.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/replication_mappings.yml`](../ansible/playbooks/replication_mappings.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/scheduled_snapshot_validation.yml`](../ansible/playbooks/scheduled_snapshot_validation.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/scheduled_tasks.yml`](../ansible/playbooks/scheduled_tasks.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/snapshot_report.yml`](../ansible/playbooks/snapshot_report.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/storage_policy_report.yml`](../ansible/playbooks/storage_policy_report.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/user_role_map.yml`](../ansible/playbooks/user_role_map.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/vm_inventory.yml`](../ansible/playbooks/vm_inventory.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/vm_os_report.yml`](../ansible/playbooks/vm_os_report.yml) | YAML parsed; live behavior unverified |
| [`ansible/playbooks/vm_power_control.yml`](../ansible/playbooks/vm_power_control.yml) | YAML parsed; live behavior unverified |
| [`ncli/assign_category.sh`](../ncli/assign_category.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/bulk_power_control.sh`](../ncli/bulk_power_control.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/bulk_vm_tagging.sh`](../ncli/bulk_vm_tagging.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/cleanup_old_snapshots.sh`](../ncli/cleanup_old_snapshots.sh) | Intentionally disabled pending version-specific API validation |
| [`ncli/cluster_health_check.sh`](../ncli/cluster_health_check.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/dr_snapshot.sh`](../ncli/dr_snapshot.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_alerts.sh`](../ncli/export_alerts.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_category_assignments.sh`](../ncli/export_category_assignments.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_cluster_version.sh`](../ncli/export_cluster_version.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_container_details.sh`](../ncli/export_container_details.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_events.sh`](../ncli/export_events.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_licenses.sh`](../ncli/export_licenses.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_pd_failover_targets.sh`](../ncli/export_pd_failover_targets.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_pd_replication.sh`](../ncli/export_pd_replication.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_pd_restore_points.sh`](../ncli/export_pd_restore_points.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_pd_schedule.sh`](../ncli/export_pd_schedule.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_roles.sh`](../ncli/export_roles.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_subnet_details.sh`](../ncli/export_subnet_details.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_users.sh`](../ncli/export_users.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_vlan_subnet.sh`](../ncli/export_vlan_subnet.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_vm_categories.sh`](../ncli/export_vm_categories.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_vm_nics.sh`](../ncli/export_vm_nics.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_vm_protection_status.sh`](../ncli/export_vm_protection_status.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/export_vm_snapshots.sh`](../ncli/export_vm_snapshots.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/list_all_categories.sh`](../ncli/list_all_categories.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/list_host_details.sh`](../ncli/list_host_details.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/list_pd.sh`](../ncli/list_pd.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/list_storage.sh`](../ncli/list_storage.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/list_vms.sh`](../ncli/list_vms.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/ncli_complex/bulk_vm_snapshot_report.sh`](../ncli/ncli_complex/bulk_vm_snapshot_report.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/ncli_complex/cleanup_old_snapshots_audit.sh`](../ncli/ncli_complex/cleanup_old_snapshots_audit.sh) | Intentionally disabled pending version-specific API validation |
| [`ncli/ncli_complex/cluster_health_audit_notify.sh`](../ncli/ncli_complex/cluster_health_audit_notify.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/ncli_complex/orphaned_vm_audit.sh`](../ncli/ncli_complex/orphaned_vm_audit.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/ncli_complex/pd_compliance_check.sh`](../ncli/ncli_complex/pd_compliance_check.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/orphaned_vm_report.sh`](../ncli/orphaned_vm_report.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/pd_restore.sh`](../ncli/pd_restore.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/pd_schedule_update.sh`](../ncli/pd_schedule_update.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/pd_snapshot.sh`](../ncli/pd_snapshot.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/snapshot_safe_check.sh`](../ncli/snapshot_safe_check.sh) | Bash syntax check in CI; live behavior unverified |
| [`ncli/utils_ncli.sh`](../ncli/utils_ncli.sh) | Shared helper; Bash syntax check in CI; live behavior unverified |
| [`python/bulk_category_assign.py`](../python/bulk_category_assign.py) | Selected logic unit-tested; live behavior unverified |
| [`python/bulk_vm_power.py`](../python/bulk_vm_power.py) | Selected logic unit-tested; live behavior unverified |
| [`python/export_cluster_alerts.py`](../python/export_cluster_alerts.py) | Compiled; live behavior unverified |
| [`python/export_recovery_points.py`](../python/export_recovery_points.py) | Compiled; live behavior unverified |
| [`python/export_snapshots.py`](../python/export_snapshots.py) | Intentionally disabled pending version-specific API validation |
| [`python/export_vm_inventory.py`](../python/export_vm_inventory.py) | Compiled; live behavior unverified |
| [`python/orphaned_vm_audit.py`](../python/orphaned_vm_audit.py) | Compiled; live behavior unverified |
| [`python/prism_client.py`](../python/prism_client.py) | Selected logic unit-tested; live behavior unverified |
