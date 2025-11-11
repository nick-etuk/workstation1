from typing import Any
import time
from workstation1.lib.logging import debug, info
from workstation1.step_done.check_step_done import check_step_done


def wait_for_new_tab(step: dict[str, Any], args: list[str]) -> bool:
    info(f"Waiting for {step['step_id']}")

    max_wait_time = 600  # seconds. Todo: read from config
    poll_interval = 5    # seconds
    waited_time = 0

    while waited_time < max_wait_time:
        step_done = check_step_done(step, args, calling_function='wait_for_new_tab')

        if step_done:
            debug(f"{step['step_id']} completed in new tab.")
            return True
        
        time.sleep(poll_interval)
        waited_time += poll_interval
        print('.', end='', flush=True)

    debug(f"Timeout waiting for {step['step_id']}")
    return False
