from typing import Any
from workstation1.lib.logging import info
from workstation1.run_step.execute_step import execute_step


def run_child_steps(parent_step: dict[str, Any], parent_args: list[str]) -> bool:
    if 'steps' not in parent_step:
        return True

    all_passed = True
    for child_step in parent_step['steps']:
        child_args: list[str] = []
        args = child_step.split(' ')
        for arg in args:
            if arg == '$@':
                child_args.extend(parent_args)
            else:
                child_args.append(arg)
        
        print(f"Running child step: {child_step} with arguments: {child_args}")
        status = execute_step(step=child_step, args=child_args, new_tab_active=False)
        if not status:
            info(f"Child step {child_step['title']} step failed")
            all_passed = False
    return all_passed
