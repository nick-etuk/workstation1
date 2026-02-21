import os
from datetime import datetime
from typing import Any
from workstation1.lib.config import config
from workstation1.lib.logging import log
from workstation1.run_step.get_step_script import get_step_script


def z_schedule_complex_step(step_id: str, args: list[str]) -> None:
    date_str = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
    task_file_name = f"{step_id}_{'_'.join(args)}_{date_str}.txt"
    task_file = os.path.join(config['working_dir'], "new_tab_queue", task_file_name)
    content = f"{step_id}"
    if len(args) > 0:
        content += f"~{'~'.join(args)}"
    with open(task_file, "w") as f:
        f.write(f"{content}\n")
    log.info(f"Added {step_id} to new tab queue.")


def schedule_step(step: dict[str, Any], args: list[str]) -> None:   
    date_str = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
    task_file_name = f"{step['step_id']}_{'_'.join(args)}" if args else f"{step['step_id']}"
    task_file_name += f"_{date_str}.txt"
    task_file = os.path.join(config['working_dir'], "new_tab_queue", task_file_name)

    if 'steps' in step or 'commands' in step:
        # Complex step. Use startup script.
        startup_script = os.path.join(config['script_root'], 'run_step', 'run_script.sh')
        step_script = f"{startup_script}"
    else:
        # Simple step. Use step script directly.
        step_script = get_step_script(step) 
        if not step_script:
            log.error(f"Cannot schedule simple step {step['step_id']} - no script file found")
            return
    
    if args:
        step_script += f" {' '.join(args)}"

    # New tab queue format:
    # step_script arg1 arg2 arg3...

    # old format:
    # step_id~step_complexity~step_script arg1 arg2 arg3...
    # row = f"{step['step_id']}~{step_complexity}~{step_script}"

    row = f"{step_script}"

    with open(task_file, "w") as f:
        f.write(f"{row}\n")
    log.info(f"Added step {step['step_id']} to new tab queue.")