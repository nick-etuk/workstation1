
from typing import Any
from workstation1.lib.config_dynamic import get_dynamic
from workstation1.lib.logging import debug, info


def check_run_once(step: dict[str, Any], args: list[str], overrides: list[str]) -> bool:
    if 'runonce' in overrides: return False
    if 'runOnce' not in step: return False
    if str(step['runOnce']).lower() != 'true': return False

    step_id = step['step_id']
    key = f"step_{step_id}"
    if len(args) > 0:
        fomatted_args = "_".join(args)
        key = f"step_{step_id}_{fomatted_args}"

    if get_dynamic(key, 'status') == 'done':
        info(f"'run once' step {step['title']} step already done")
        return True

        
    debug(f"'run once' step {step['title']} has not been run yet")
    return False