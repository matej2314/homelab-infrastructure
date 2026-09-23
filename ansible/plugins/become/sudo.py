# -*- coding: utf-8 -*-
"""Override builtin sudo become: match Ubuntu/sudo 1.9.17+ prompt wrapping.

Newer sudo prints:
  [sudo: <custom-prompt>] Password:
Ansible 2.20.1 looks for a line that *startswith* the custom prompt, never
matches, and times out after 12s. Interactive sudo in a TTY still works.

Must load the builtin from disk — a plugin named sudo would otherwise
circular-import this file as ansible.plugins.become.sudo.
"""
from __future__ import annotations

import importlib.util
import os

from ansible.module_utils.common.text.converters import to_bytes
from ansible.plugins import become as become_pkg

_builtin_path = os.path.join(os.path.dirname(become_pkg.__file__), "sudo.py")
_spec = importlib.util.spec_from_file_location("_ansible_builtin_sudo_become", _builtin_path)
_mod = importlib.util.module_from_spec(_spec)
assert _spec.loader is not None
_spec.loader.exec_module(_mod)
_BuiltinSudoBecomeModule = _mod.BecomeModule
DOCUMENTATION = _mod.DOCUMENTATION


class BecomeModule(_BuiltinSudoBecomeModule):
    def check_password_prompt(self, b_output):
        if not self.prompt:
            return False
        b_prompt = to_bytes(self.prompt).strip()
        return b_prompt in b_output
