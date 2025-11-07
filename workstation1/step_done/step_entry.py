from typing import Any, Dict
from workstation1.step_done.check_dependencies import check_dependencies
from workstation1.lib.logging import info
from workstation1.step_done.check_step_done import check_step_done

def step_entry(step: Dict[str, Any], step_args: list[str]):
    if not check_dependencies(step, step_args):
        return False

    if check_step_done(step=step, step_args=step_args, calling_function='step_entry'):
        info(f"{step['description']} step already done")
        return False
    
    return True
