import os
import json
from typing import Any

from workstation1.lib.config_dynamic import get_dynamic, set_dynamic
from workstation1.lib.logging import debug, error, info, warn
from icecream import ic

def is_absolute_path(path: str) -> bool:
    return path == '/' or (len(path) >= 2 and path[1] == ':' and len(path) == 2)

def expand_path(path: str) -> str:
    expanded_path = os.path.expandvars(path)
    if not os.path.isdir(expanded_path):
        error(f"Path does not exist: {expanded_path}. Aborting.")
        return
    return expanded_path

def set_current_project(project_registry: list[dict[str, Any]], step_registry_entry: dict[str, Any]) -> None:
    with open(step_registry_entry['path']) as f:
        step = json.load(f)
    if not ('menu' in step and step['menu'] == 'main'): return

    step_project_id = step_registry_entry['project_id']
    current_project_id = get_dynamic('current_project_id')
    if current_project_id == step_project_id:
        debug(f"Current project unchanged  from {current_project_id}")
        return
    
    info(f"Setting current project id to {step_project_id}")
    set_dynamic('current_project_id', step_project_id)

    project_found = False
    for project in project_registry:
        ic(project)
        if project['project_id'] == step['project_id']:
            project_found = True
            set_project_root(project, step)
    if not project_found:
        warn(f"Project id {step['project_id']} not found in project registry. Could not set current project root.")    
    
def set_project_root(project: dict[str, Any], step: dict[str, Any]) -> None:  
    if 'projectRoot' not in project:
        with open(os.path.join(project['path'], 'ws1', 'ws1_project.json')) as f:
            project_config = json.load(f)
        project['projectRoot'] = project_config.get('projectRoot', project['path'])
    
    debug(f"Setting current project root to {project['projectRoot']}")
    set_dynamic('current_project_root', expand_path(project['projectRoot']))

    if 'exitTo' not in step:
        step['step_id'] = step.get('id', step['step_id'])
        debug(f"Using step_id ({step['step_id']}) as exitTo")
        step['exitTo'] = step['step_id']
        
    if is_absolute_path(step['exitTo']):
        debug(f"Setting current project path to absolute path {step['exitTo']}")
        set_dynamic('current_project_path', expand_path(step['exitTo']))
    else:
        exit_to_path = os.path.join(project['projectRoot'], str(step['exitTo']))
        debug(f"Setting current project path to {exit_to_path}")
        set_dynamic('current_project_path', expand_path(exit_to_path))
 