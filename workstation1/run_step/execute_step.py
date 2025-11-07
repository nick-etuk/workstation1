from datetime import datetime
import subprocess
import json
from typing import Any, Dict
# from icecream import ic
from workstation1.lib.config import config
from workstation1.run_step.open_new_tab import open_new_tab
from workstation1.lib.logging import debug, info
from workstation1.step_done.step_entry import step_entry
from workstation1.step_done.step_exit import step_exit

from workstation1.run_step.enrich_step import enrich_step

def execute_step(parent_registry_entry: Dict[str, Any], parent_step_args: list[str], new_tab_active: bool = False):
    parent_step_id = parent_registry_entry['step_id']
    print(f"Running step: {parent_step_id} with arguments: {parent_step_args}")

    base_step = {}
    with open(parent_registry_entry['path']) as f:
        base_step = json.load(f)

    parent_step = enrich_step(base_step, parent_registry_entry)

    if 'os' in parent_step:
        if parent_step['os'] != config['my_os'] and parent_step['os'] != 'unix':
            print(f"Step {parent_step_id} not for {config['my_os']}")
            return
    
    run_once = False
    key = f"step_{parent_step_id}"
    if 'run_once' in parent_step and parent_step['run_once'] == True:
        run_once = True
        if len(parent_step_args) > 0:
            fomatted_args = "_".join(parent_step_args)
            key = f"step_{parent_step_id}_{fomatted_args}"

        # status = get_dynamic("status", key)
        status = 'done' # Placeholder for actual status retrieval

        if status == 'done':
            info(f"{parent_step['description']} step already done")
            return

    run_always = False
    if 'runAlways' in parent_step and parent_step['runAlways'] == True:
        run_always = True
        debug(f"runAlways is true for step {parent_step_id}")
    else:
        if not step_entry(step=parent_step, step_args=parent_step_args):
            return
        
    all_passed = True

    # Run inline step commands here. Do not exit afterwards.

    # Run child steps here. Do not exit afterwards.

    if not new_tab_active and 'newTab' in parent_step and parent_step['newTab'] == True:
        date_str = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
        step_filename = f"{parent_step_id}_{'_'.join(parent_step_args)}_{date_str}.txt"
        content = f"{parent_step_id}~{'~'.join(parent_step_args)}"
        with open(f"{config['working_dir']}/new_tab_queue/{step_filename}", "w") as f:
            f.write(content)
        print(f"Added step {parent_step_id} to new tab queue.")
        open_new_tab()
        return

    if config['my_os'] == 'win': # type: ignore
        step_script = f"{parent_step['dir']}/{parent_step_id}.ps1"
        process = subprocess.run(['powershell.exe', '-ExecutionPolicy', 'Bypass', '-File', step_script, *parent_step_args])
    else:
        startup_script = f"{config['script_root']}/cli/ws_run_step.sh"
        process = subprocess.run(['bash', startup_script, f"{parent_step['dir']}/{parent_step_id}.sh", *parent_step_args])

    print(f"Step {parent_step_id} exited with code {process.returncode}. Output:")
    print(process.stdout)


    if not run_always:
        if not step_exit(step=parent_step, step_args=parent_step_args, new_tab_active=new_tab_active):
            all_passed = False

    if all_passed:
        if run_once:
            # set_dynamic("status", key, 'done') todo: implement
            pass
    else:
        if new_tab_active:
            info(f"{parent_step['description']} step failed in new tab")
        else:
            info(f"{parent_step['description']} step failed")
