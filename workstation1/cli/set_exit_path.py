import os
import json
from typing import Any

from workstation1.lib.config_dynamic import set_dynamic
from workstation1.lib.logging import debug, warn
# from icecream import ic

def is_root_path(path: str) -> bool:
    return path == '/' or (len(path) >= 2 and path[1] == ':' and len(path) == 2)

def set_exit_path(project_registry: list[dict[str, Any]], step_registry_entry: dict[str, Any]) -> None:
    with open(step_registry_entry['path']) as f:
        step = json.load(f)
    
    if not ('menu' in step and step['menu'] == 'main'): return
    
    step['step_id'] = step.get('id', step_registry_entry['step_id'])
    # ic(step)
    if 'exitTo' not in step:
        debug(f"Using step_id ({step['step_id']}) as exit path")
        step['exitTo'] = step['step_id']
        
    exit_to_path = ''
    if is_root_path(step['exitTo']):
        debug(f"Setting current exit path to absolute path {step['exitTo']}")
        raw_path = str(step['exitTo'])
        exit_to_path = os.path.expandvars(raw_path)
        set_dynamic('current_exit_path', exit_to_path)
        return
    
    for project in project_registry:
        if project['project_id'] == step_registry_entry['project_id']:
            if 'projectRoot' not in project:
                with open(os.path.join(project['path'], 'ws1', 'ws1_project.json')) as f:
                    project_config = json.load(f)
                project['projectRoot'] = project_config.get('projectRoot', project['path'])
            
            raw_path = os.path.join(project['projectRoot'], str(step['exitTo']))
            exit_to_path = os.path.expandvars(raw_path)
            debug(f"Setting current exit path to {exit_to_path}")
            # debug(f"Resolved from relative exit path {step['exitTo']} and project root {project['projectRoot']}")
            if not os.path.isdir(exit_to_path):
                debug(f"Exit path does not exist: {exit_to_path}. Using project root {project['projectRoot']} instead.")
                raw_path = project['projectRoot']
                exit_to_path = os.path.expandvars(raw_path)
                if not os.path.isdir(exit_to_path):
                    warn(f"Exit path does not exist: {exit_to_path}. Aborting.")
                    return
                
            set_dynamic('current_exit_path', exit_to_path)
            return