"""Tests for Prism pagination and VM name resolution.

Author: Paul Bryant
"""

import importlib.util
from pathlib import Path
import sys
from types import ModuleType
import unittest
from unittest.mock import patch


SCRIPT = Path(__file__).parents[1] / "python" / "prism_client.py"
SPEC = importlib.util.spec_from_file_location("prism_client", SCRIPT)
MODULE = importlib.util.module_from_spec(SPEC)
dotenv_stub = ModuleType("dotenv")
dotenv_stub.load_dotenv = lambda _path: None
with patch.dict(sys.modules, {"requests": ModuleType("requests"), "dotenv": dotenv_stub}):
    SPEC.loader.exec_module(MODULE)


class FakeResponse:
    def __init__(self, payload):
        self.payload = payload

    def raise_for_status(self):
        return None

    def json(self):
        return self.payload


class FakeSession:
    def __init__(self, pages):
        self.pages = pages
        self.headers = {}
        self.calls = []

    def post(self, url, json, timeout):
        self.calls.append((url, json, timeout))
        return FakeResponse(self.pages.pop(0))

    def close(self):
        return None


class PrismClientTests(unittest.TestCase):
    def test_list_fetches_all_pages(self):
        pages = [
            {
                "entities": [{"metadata": {"uuid": "1"}}, {"metadata": {"uuid": "2"}}],
                "metadata": {"total_matches": 3},
            },
            {
                "entities": [{"metadata": {"uuid": "3"}}],
                "metadata": {"total_matches": 3},
            },
        ]
        session = FakeSession(pages)
        client = MODULE.PrismClient("prism.example.local", "user", "secret", session)
        result = list(client.list_entities("vm", page_size=2))
        self.assertEqual([vm["metadata"]["uuid"] for vm in result], ["1", "2", "3"])
        self.assertEqual([call[1]["offset"] for call in session.calls], [0, 2])
        self.assertTrue(all(call[2] == 30 for call in session.calls))

    def test_duplicate_names_are_rejected(self):
        session = FakeSession([
            {
                "entities": [
                    {"spec": {"name": "same"}, "metadata": {"uuid": "1"}},
                    {"spec": {"name": "same"}, "metadata": {"uuid": "2"}},
                ],
                "metadata": {"total_matches": 2},
            }
        ])
        client = MODULE.PrismClient("prism.example.local", "user", "secret", session)
        with self.assertRaises(ValueError):
            client.vm_uuid_by_name("same")


if __name__ == "__main__":
    unittest.main()
