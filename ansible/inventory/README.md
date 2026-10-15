# Inventory Folder for Nutanix AHV Automation

- **hosts.ini**: Static Ansible inventory for Prism Central, DR, Element, and localhost.
- **group_vars/**: Per-group non-secret variables (add more as needed).
- **host_vars/**: Per-host variables for localhost or other special hosts.
- All API secrets (usernames/passwords) must be stored in `.env.ansible_vault` and NOT in inventory.

**Update hosts.ini and group_vars to reflect your real Nutanix deployment.**

For dynamic environments, you can script inventory generation or use Ansible dynamic inventory plugins.
