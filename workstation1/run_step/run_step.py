import json
from typing import Any
from workstation1.run_step.enrich_step import enrich_step
from workstation1.run_step.execute_step import execute_step


def run_step(step_registry_entry: dict[str, Any], step_args: list[str], new_tab_active: bool = False) -> bool:
    base_step = {}
    with open(step_registry_entry['path']) as f:
        base_step = json.load(f)

    step = enrich_step(base_step, step_registry_entry)

    return execute_step(parent_step=step, parent_args=step_args, new_tab_active=new_tab_active)