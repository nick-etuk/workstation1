
import subprocess
from typing import Any
from workstation1.lib.logging import warn


def check_docker(type: str, step: dict[str, Any], calling_function: str) -> bool:
    if type == 'containers':
        commandline = ['docker', 'container', 'ls', '--format', '{{.Names}}']
        config_property = 'dockerContainers'
    elif type == 'images':
        commandline = ['docker', 'image', 'ls', '--format', '{{.Repository}}:{{.Tag}}']
        commandline = ['docker', 'image', 'ls', '--format', '{{.Repository}}']
        config_property = 'dockerImages'
    else:
        warn(f"Unknown docker check type: {type}")
        return False
    
    if not ('checks' in step and config_property in step['checks']):
        return True
    
    expected_items = step['checks'][config_property]
    actual_items = []
    # docker container ls --format "{{.Names}}"
    process = subprocess.run(commandline, capture_output=True, text=True)
    if process.returncode != 0:
        warn("Failed to list Docker containers. Is Docker running?")
        return False
    actual_items = process.stdout.strip().lower().split('\n')
    expected_items = [c.lower() for c in expected_items]
    # missing_containers = [c for c in expected_containers if c not in actual_containers]
    missing_items: list[str] = []
    unexpected_items: list[str] = []
    for expected in expected_items:
        found = False
        for actual in actual_items:
            if expected in actual:
                found = True
                continue
            else:
                if actual not in unexpected_items: # avoid duplicates
                    unexpected_items.append(actual)
        if not found:
            if expected not in missing_items: # avoid duplicates
                missing_items.append(expected)

    if len(missing_items) > 0:
        missing_items.sort()
        if not calling_function == 'wait_for_new_tab':
            list = "\n".join(missing_items)
            warn(f"Missing Docker {type}: {list}")
        return False

    if len(unexpected_items):
        unexpected_items.sort()
        if not calling_function == 'wait_for_new_tab':
            list = "\n".join(unexpected_items)
            warn(f"Unexpected Docker {type}: {list}")
    
    return True
