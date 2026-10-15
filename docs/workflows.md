# Representative workflows

Author: Paul Bryant

These examples document behavior visible in source and unit tests. No live Prism or AHV result has been measured for this repository.

## VM inventory export

[`export_vm_inventory.py`](../python/export_vm_inventory.py) reads the Prism Central v3 VM list in pages and writes a CSV of names, UUIDs, power states, and category keys.

```text
python python/export_vm_inventory.py --csv vm_inventory.csv
```

The shared client has unit tests for pagination. Validate credentials, permissions, and the actual response shape on your Prism Central release before relying on the CSV.

## Bulk VM power

[`bulk_vm_power.py`](../python/bulk_vm_power.py) reads a CSV with `VMName,Action` columns. Only `ON` and `OFF` are accepted. It resolves unique VM names and prints the planned actions. `--apply` reads each current VM definition, preserves its existing specification, and submits a power-state update. A successful API response means a task was accepted; check the resulting Prism task before treating the change as complete.

Example `power_actions.csv`:

```csv
VMName,Action
example-vm,OFF
```

```text
python python/bulk_vm_power.py --csv power_actions.csv
python python/bulk_vm_power.py --csv power_actions.csv --apply
```

Unit tests cover invalid actions and preservation of other VM settings. The API write path has not been tested against a live cluster.

## Bulk category assignment

[`bulk_category_assign.py`](../python/bulk_category_assign.py) reads `VMName,CategoryKey,CategoryValue` rows. It previews the changes, checks category values during apply, and keeps existing category assignments in the submitted VM definition.

Example `category_assignments.csv`:

```csv
VMName,CategoryKey,CategoryValue
example-vm,Environment,Test
```

```text
python python/bulk_category_assign.py --csv category_assignments.csv
python python/bulk_category_assign.py --csv category_assignments.csv --apply
```

Unit tests cover preservation of existing values. Confirm category permissions, target VM identity, task completion, and rollback steps in a nonproduction Prism environment.
