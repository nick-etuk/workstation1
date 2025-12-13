import os
from datetime import datetime
from workstation1.lib.config import config
from workstation1.lib.logging import log

def schedule_step(step_id: str, args: list[str]) -> None:
    date_str = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
    task_file_name = f"{step_id}_{'_'.join(args)}_{date_str}.txt"
    task_file = os.path.join(config['working_dir'], "new_tab_queue", task_file_name)
    content = f"{step_id}"
    if len(args) > 0:
        content += f"~{'~'.join(args)}"
    with open(task_file, "w") as f:
        f.write(f"{content}\n")
    log.info(f"Added {step_id} to new tab queue.")
    