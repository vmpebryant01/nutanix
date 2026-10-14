"""Shared Prism Central v3 client for repository examples.

Author: Paul Bryant
"""

import os

import requests
from dotenv import load_dotenv


class PrismClient:
    def __init__(self, server, user, password, session=None):
        if not all((server, user, password)):
            raise ValueError("Set PRISM_CENTRAL, PRISM_USER, and PRISM_PASS")
        if "://" in server or "/" in server:
            raise ValueError("PRISM_CENTRAL must be a hostname or IP address")
        self.base_url = f"https://{server}:9440/api/nutanix/v3"
        self.session = session or requests.Session()
        self.session.auth = (user, password)
        self.session.verify = os.getenv("PRISM_CA_BUNDLE") or True
        self.session.headers.update({"Content-Type": "application/json"})

    @classmethod
    def from_env(cls, env_file=".env"):
        load_dotenv(env_file)
        return cls(
            os.getenv("PRISM_CENTRAL"),
            os.getenv("PRISM_USER"),
            os.getenv("PRISM_PASS"),
        )

    def close(self):
        self.session.close()

    def __enter__(self):
        return self

    def __exit__(self, _type, _value, _traceback):
        self.close()

    def post(self, path, body):
        response = self.session.post(f"{self.base_url}/{path}", json=body, timeout=30)
        response.raise_for_status()
        return response

    def get(self, path):
        response = self.session.get(f"{self.base_url}/{path}", timeout=30)
        response.raise_for_status()
        return response

    def put(self, path, body):
        response = self.session.put(f"{self.base_url}/{path}", json=body, timeout=30)
        response.raise_for_status()
        return response

    def list_entities(self, kind, page_size=200):
        if not kind.isidentifier():
            raise ValueError(f"Invalid Prism entity kind: {kind!r}")
        offset = 0
        while True:
            response = self.post(
                f"{kind}s/list",
                {"kind": kind, "length": page_size, "offset": offset},
            ).json()
            entities = response.get("entities", [])
            if not isinstance(entities, list):
                raise ValueError("Prism returned an invalid entity list")
            yield from entities
            offset += len(entities)
            total = response.get("metadata", {}).get("total_matches")
            if not entities or (total is not None and offset >= total):
                break
            if total is None and len(entities) < page_size:
                break

    def vm_uuid_by_name(self, name):
        matches = [
            vm["metadata"]["uuid"]
            for vm in self.list_entities("vm")
            if vm.get("spec", {}).get("name") == name
        ]
        if len(matches) != 1:
            raise ValueError(f"Expected one VM named {name!r}; found {len(matches)}")
        return matches[0]
