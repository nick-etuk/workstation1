
from typing import Any
from workstation1.lib.logging import debug, warn
from workstation1.run_step.load_step import load_step
from workstation1.step_done.check_step_done import check_step_done
from workstation1.step_done.wait_for_new_tab import wait_for_new_tab

def check_dependencies(step: dict[str, Any], args: list[str]) -> bool:
    if 'dependencies' not in step:
        return True

    for dependency in step['dependencies']:
        debug(f"Checking {step['step_id']} dependency {dependency}")
        dependency_step = load_step(dependency)
        if check_step_done(step=dependency_step, step_args=args, calling_function='check_dependencies'):
            continue
        
        if 'newTab' in dependency_step and str(dependency_step['newTab']).lower() == 'true':
            if wait_for_new_tab(dependency_step, args):
                continue

        warn(f"{step['step_id']} not attempted because {dependency} is not done")
        return False
    
    return True
