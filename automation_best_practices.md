# Using the Nutanix examples

Author: Paul Bryant

The examples in this repository have not been run against a live Prism or AHV environment here. Check the [script status](docs/script_status.md) and the API available on your installed release before use.

- Review every CSV row and target identifier before a bulk operation. The sample CSV files contain headers only.
- Run preview mode where a script provides it. For the Python bulk power and category scripts, `--apply` submits changes to Prism.
- Keep credentials in an ignored local file or your normal secret store. Trust the issuing CA rather than disabling certificate checks.
- Record the Prism task ID after a change request. An accepted API request does not mean the task finished successfully.
- Take a backup or snapshot when the planned change warrants one, and verify that recovery is possible for the affected workload.
- Confirm the endpoint, payload, permissions, and rollback procedure for Ansible and NCLI examples on your release. Some of those workflows still need live validation.
