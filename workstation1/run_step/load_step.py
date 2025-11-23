import csv
import json
from typing import Any
from workstation1.lib.config import config
from workstation1.lib.logging import warn
from workstation1.run_step.enrich_step import enrich_step
from workstation1.registry.update_step_registry import update_step_registry
from workstation1.registry.get_registries import project_registry


def load_step(step_id: str) -> dict[str, Any]:
    step_registry_file = f"{config['working_dir']}/step_registry.csv"
    
    with open(step_registry_file) as f:
        reader = csv.DictReader(f)
        steps = [row for row in reader if row['step_id'] == step_id]
        if not steps:
            warn(f"Step {step_id} not found in registry.")
            if input("Rescan step registry? (y/n): ").lower() == 'y':
                update_step_registry(project_registry=project_registry())
                f.seek(0)
                reader = csv.DictReader(f)
                steps = [row for row in reader if row['step_id'] == step_id]
            if not steps:
                raise ValueError(f"Step {step_id} not found in registry")
        registry_entry = steps[0]
    
    with open(registry_entry['path']) as f:
        base_step = json.load(f)

    step = enrich_step(base_step=base_step, registry_entry=registry_entry)
    return step
