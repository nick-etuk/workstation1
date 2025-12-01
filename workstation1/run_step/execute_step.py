from typing import Any
from workstation1.lib.config import config
from workstation1.lib.config_dynamic import get_dynamic, set_dynamic
from workstation1.run_step.schedule_step import schedule_step
from workstation1.run_step.invoke_commands import invoke_commands
from workstation1.run_step.load_step import load_step
from workstation1.run_step.invoke_step import invoke_step
from workstation1.run_step.open_new_tab import open_new_tab
from workstation1.lib.logging import debug, info
from workstation1.step_done.check_dependencies import check_dependencies
from workstation1.step_done.step_entry import step_entry
from workstation1.step_done.step_exit import step_exit

# from icecream import ic


def run_child_steps(parent_step: dict[str, Any], parent_args: list[str], parent_overrides: list[str]) -> bool:
    if 'steps' not in parent_step:
        return True
    all_passed = True
    for child_step_row in parent_step['steps']:
        child_args: list[str] = []
        args = child_step_row.split(' ')
        for arg in args:
            if arg == '$@':
                child_args.extend(parent_args)
            else:
                child_args.append(arg)

        child_step_id = child_args[0]
        child_step_args = child_args[1:]
        child_step = load_step(child_step_id)
        
        if child_step_args and len(child_step_args) > 0:
            debug(f"Running child step: {child_step['step_id']} with arguments: {child_step_args}")
        else:
            debug(f"Running child step: {child_step['step_id']}")

        status = execute_step(step=child_step, args=child_step_args, overrides=parent_overrides, new_tab_active=False)
        if not status:
            all_passed = False
    return all_passed

def execute_step(step: dict[str, Any], args: list[str], overrides: list[str], new_tab_active: bool = False) -> bool:
    step_id = step['step_id']

    if 'os' in step and step['os'] != config['my_os'] and step['os'] != 'unix':
        print(f"Step {step_id} not for {config['my_os']}")
        return True
    
    if 'isActive' in step and str(step['isActive']).lower() == 'false':
        info(f"Step {step_id} is inactive")
        return True

    run_always = False
    if ('runAlways' in step and str(step['runAlways']).lower() == 'true'):
        run_always = True
        debug(f"runAlways is true for step {step_id}")
        if 'dependencies' not in overrides and not check_dependencies(step, args):
            debug(f"{step['title']} failed dependencies")
            return False
    
    if not run_always and 'dependencies' not in overrides:
        ok_to_proceed = step_entry(step=step, step_args=args)
        if ok_to_proceed['status'] is False:
            if ok_to_proceed['reason'] == 'done':
                return True  # step already done
            else:
                return False  # failed dependencies
    
    run_once = False
    key = f"step_{step_id}"
    if 'runOnce' in step and str(step['runOnce']).lower() == 'true':
        run_once = True
        if len(args) > 0:
            fomatted_args = "_".join(args)
            key = f"step_{step_id}_{fomatted_args}"

        status = get_dynamic(key, 'status')

        if status == 'done':
            info(f"{step['title']} (run once) step already done")
            if 'runonce' in overrides:
                info(f"Overriding run once for step {step_id}")
            else:
                return True
            
    if not new_tab_active and 'newTab' in step and str(step['newTab']).lower() == 'true':
        schedule_step(step_id=step_id, args=args)
        open_new_tab()
        return True
            
    all_passed = True

    if 'commands' in step:
        invoke_commands(step['commands'])

    all_passed = run_child_steps(parent_step=step, parent_args=args, parent_overrides=overrides) and all_passed
    debug("bp1 executing step after running child steps")

    debug(f"bp2 new_tab_active: {new_tab_active}")

    # if not new_tab_active:
    invoke_step(step=step, args=args)

    if not run_always:
        if not step_exit(step=step, step_args=args, new_tab_active=new_tab_active):
            all_passed = False

    if all_passed:
        if run_once:
            set_dynamic(key, 'done', 'status')
    else:
        if new_tab_active:
            info(f"{step['title']} step failed in new tab")
        else:
            info(f"{step['title']} step failed")

    return all_passed