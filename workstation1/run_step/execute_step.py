import os
from datetime import datetime
from typing import Any
from workstation1.lib.config import config
from workstation1.lib.config_dynamic import get_dynamic, set_dynamic
from workstation1.run_step.invoke_commands import invoke_commands
from workstation1.run_step.load_step import load_step
from workstation1.run_step.invoke_step import invoke_step
from workstation1.run_step.open_new_tab import open_new_tab
from workstation1.lib.logging import debug, info
from workstation1.step_done.check_dependencies import check_dependencies
from workstation1.step_done.step_entry import step_entry
from workstation1.step_done.step_exit import step_exit

# from icecream import ic


def run_child_steps(parent_step: dict[str, Any], parent_args: list[str]) -> bool:
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
            # debug(f"Running child step: {child_step['step_id']} with arguments: {child_step_args}")
            pass
        else:
            # debug(f"Running child step: {child_step['step_id']}")
            pass

        status = execute_step(parent_step=child_step, parent_args=child_step_args, new_tab_active=False)
        if not status:
            all_passed = False
    return all_passed

def execute_step(parent_step: dict[str, Any], parent_args: list[str], new_tab_active: bool = False) -> bool:
    parent_step_id = parent_step['step_id']
    if parent_args and len(parent_args) > 0:
        debug(f"Running step {parent_step_id} with args: {parent_args}")
    else:
        debug(f"Running step {parent_step_id}")

    if 'os' in parent_step:
        if parent_step['os'] != config['my_os'] and parent_step['os'] != 'unix':
            print(f"Step {parent_step_id} not for {config['my_os']}")
            return True
    
    run_once = False
    key = f"step_{parent_step_id}"
    if 'runOnce' in parent_step and str(parent_step['runOnce']).lower() == 'true':
        run_once = True
        if len(parent_args) > 0:
            fomatted_args = "_".join(parent_args)
            key = f"step_{parent_step_id}_{fomatted_args}"

        status = get_dynamic("status", key)

        if status == 'done':
            info(f"{parent_step['title']} (run once) step already done")
            return True

    run_always = False
    if 'runAlways' in parent_step and str(parent_step['runAlways']).lower() == 'true':
        run_always = True
        debug(f"runAlways is true for step {parent_step_id}")
        if not check_dependencies(parent_step, parent_args):
            debug(f"{parent_step['title']} failed dependencies")
            return False
    else:
        # if not step_entry(step=parent_step, step_args=parent_args):
        ok_to_proceed = step_entry(step=parent_step, step_args=parent_args)
        if ok_to_proceed['status'] is False:
            if ok_to_proceed['reason'] == 'done':
                return True  # step already done
            else:
                return False  # failed dependencies
        
    all_passed = True

    if 'commands' in parent_step:
        invoke_commands(parent_step['commands'])

    all_passed = run_child_steps(parent_step=parent_step, parent_args=parent_args) and all_passed

    if not new_tab_active and 'newTab' in parent_step and str(parent_step['newTab']).lower() == 'true':
        step_script = os.path.join(parent_step['dir'], f"{parent_step_id}.sh")
        if os.path.exists(step_script):
            date_str = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
            task_file_name = f"{parent_step_id}_{'_'.join(parent_args)}_{date_str}.txt"
            task_file = os.path.join(config['working_dir'], "new_tab_queue", task_file_name)
            # content = f"{parent_step_id}~{'~'.join(parent_args)}"
            content = f"{step_script}~{'~'.join(parent_args)}"
            with open(task_file, "w") as f:
                f.write(f"{content}\n")
            print(f"Added {parent_step_id} to new tab queue.")
            open_new_tab()
            # time.sleep(5)
        return True

    if not new_tab_active:
        invoke_step(step=parent_step, args=parent_args)

    if not run_always:
        if not step_exit(step=parent_step, step_args=parent_args, new_tab_active=new_tab_active):
            all_passed = False

    if all_passed:
        if run_once:
            set_dynamic("status", key, 'done')
    else:
        if new_tab_active:
            info(f"{parent_step['title']} step failed in new tab")
        else:
            info(f"{parent_step['title']} step failed")

    return all_passed