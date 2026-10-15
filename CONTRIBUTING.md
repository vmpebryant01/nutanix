# Contributing

Author: Paul Bryant

Issue reports are welcome. Contact the maintainer through an issue before submitting code so contribution and reuse permission can be agreed in writing, along with the intended Prism Central, Prism Element, or AHV version and API scope.

- Include the exact product release, API version, command or playbook, operating system, and a sanitized reproduction when reporting a defect.
- Keep credentials and customer data out of commits, logs, tests, and issue comments. Use encrypted Ansible Vault files or local ignored environment files as appropriate. Verify TLS certificates.
- For infrastructure changes, include a preview or explicit target scope, explain task completion and failure behavior, and add focused tests where the logic can be tested without a live cluster.
- Run the checks in `.github/workflows/checks.yml` locally where possible. State which checks ran and whether a live test was performed. Static checks alone do not establish release compatibility.
- Update the README, [script status](docs/script_status.md), and [workflow notes](docs/workflows.md) when behavior or support claims change.

The repository is all rights reserved. Opening a pull request does not change the reuse terms. See [copyright and reuse](COPYRIGHT.md).
