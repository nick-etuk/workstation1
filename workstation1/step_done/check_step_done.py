import subprocess
from typing import Any, Dict
# from icecream import ic
from workstation1.lib.config import config
from workstation1.lib.logging import info, warn, error

def check_step_done(step: Dict[str, Any], step_args: list[str], calling_function: str) -> bool:

    # todo: check if FORCE mode is enabled
    
    if 'checks' not in step:
        return True
    
    checks: list[str] = []
    startup_script = f"{config['script_root']}/cli/ws_run_checks.sh"

    if config['my_os'] in step['checks']:
        checks += step['checks'][config['my_os']]
    
    if config['my_os'] != 'win' and 'unix' in step['checks']: # type: ignore
        checks += step['checks']['unix']

    if len(checks) == 0:
        if calling_function in ['step_exit', 'check_dependencies']:
            return True
        error(f"Empty checks defined for step {step['step_id']}")
        
        return False

    process = subprocess.run(
        ['bash', startup_script] + checks,
        capture_output=True,
        text=True)
    ret_code = process.returncode
    if ret_code == 0:
        return True
    else:
        if calling_function == 'step_exit':
            warn(f"{step['step_id']} {' '.join(step_args)} step failed")
            info(f"Checks: {','.join(checks)}")
            info(f"Result: {ret_code}")
            info(f"output: {process.stdout}")
            # show_help(step['step_id'])
        return False
    