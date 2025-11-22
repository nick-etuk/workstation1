import os
from pathlib import Path
import csv
from typing import Any
from workstation1.lib.config import config
from workstation1.registry.find_steps import find_steps
from workstation1.lib.logging import info, warn
from icecream import ic

def update_step_registry(project_registry: list[dict[str, Any]]) -> None:
    info("Updating step registry")
    step_registry_file = f"{config['working_dir']}/step_registry.csv"

    if Path(step_registry_file).exists():
        os.remove(step_registry_file)

    combined_step_registry: list[dict[str, Any]] = []
    ic(project_registry)
    for project in project_registry:
        info(f"Scanning {project['project_id']} at {project['path']}")
        if not os.path.exists(project['path']):
            warn(f"Project {project['project_id']} - path does not exist: {project['path']}")
            continue
        # project_dir = Path(project['path']).parent
        project_dir = Path(project['path'])
        step_registry = find_steps(project['project_id'], str(project_dir))
        if not step_registry:
            continue
        info(f"Found {len(step_registry)} steps in {project['project_id']}")
        combined_step_registry.extend(step_registry)

    # project_dir = Path(config['script_root'])
    step_registry = find_steps('core', config['script_root'])
    if step_registry:
        info(f"Found {len(step_registry)} steps in core")
        combined_step_registry.extend(step_registry)
    
    combined_step_registry = sorted(combined_step_registry, key=lambda x: (x['sort_order']))

    with open(step_registry_file, 'w', newline='') as csvfile:
        # fieldnames = combined_step_registry[0].keys() if combined_step_registry else ['step_id', 'sort_order', 'project_id', 'title', 'menu', 'step_file']
        fieldnames = combined_step_registry[0].keys()
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for step in combined_step_registry:
            writer.writerow({
                'step_id': step['step_id'],
                'sort_order': step['sort_order'],
                'project_id': step['project_id'],
                'menu': step['menu'],
                'title': step['title'],
                'path': step['path'],
            })

