# Automation Best Practices

- Always test in a non-production cluster with dry-run mode.
- Use CSV-driven bulk changes to standardize, document, and validate all inputs.
- Validate Nutanix Prism API version before running any script.
- Store credentials in `.env` (never in scripts).
- Use SSH key-based auth for NCLI scripting.
- Always run a health check and snapshot before making bulk changes.
- Schedule automated reporting and keep audit logs.
- Self-heal and remediation playbooks should log all actions and require confirmation for destructive changes.
- Integrate with CMDB, monitoring, and backup for end-to-end visibility.
