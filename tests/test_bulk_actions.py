"""Tests for validated bulk VM actions.

Author: Paul Bryant
"""

import importlib.util
from io import StringIO
from pathlib import Path
import sys
from types import ModuleType
import unittest
from unittest.mock import patch


root = Path(__file__).parents[1] / "python"
client_stub = ModuleType("prism_client")
client_stub.PrismClient = object


def load_script(name):
    path = root / name
    spec = importlib.util.spec_from_file_location(name.removesuffix(".py"), path)
    module = importlib.util.module_from_spec(spec)
    with patch.dict(sys.modules, {"prism_client": client_stub}):
        spec.loader.exec_module(module)
    return module


power = load_script("bulk_vm_power.py")
category = load_script("bulk_category_assign.py")


class BulkActionTests(unittest.TestCase):
    def test_reset_action_is_rejected(self):
        sample = "VMName,Action\nvm-1,RESET\n"
        with patch("builtins.open", return_value=StringIO(sample)):
            with self.assertRaises(ValueError):
                power.read_actions("unused.csv")

    def test_power_update_keeps_complete_spec_and_does_not_mutate_source(self):
        current = {
            "spec": {"name": "vm-1", "resources": {"power_state": "OFF", "disk_list": [1]}},
            "metadata": {"uuid": "123"},
            "status": {"state": "COMPLETE"},
        }
        updated = power.with_power_state(current, "ON")
        self.assertEqual(updated["spec"]["resources"]["disk_list"], [1])
        self.assertEqual(updated["spec"]["resources"]["power_state"], "ON")
        self.assertNotIn("status", updated)
        self.assertEqual(current["spec"]["resources"]["power_state"], "OFF")

    def test_category_update_preserves_other_values(self):
        current = {
            "spec": {"name": "vm-1", "resources": {"disk_list": [1]}},
            "metadata": {"categories_mapping": {"Environment": ["Dev"]}},
            "status": {},
        }
        updated = category.with_category(current, "Environment", "Prod")
        self.assertEqual(updated["metadata"]["categories_mapping"]["Environment"], ["Dev", "Prod"])
        self.assertEqual(updated["spec"]["resources"]["disk_list"], [1])
        self.assertNotIn("status", updated)
        self.assertEqual(current["metadata"]["categories_mapping"]["Environment"], ["Dev"])


if __name__ == "__main__":
    unittest.main()
