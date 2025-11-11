
from typing import Any
import os
import subprocess
from workstation1.lib.config import config
from workstation1.lib.logging import debug
# from icecream import ic


def invoke_step(step: dict[str, Any], args: list[str]) -> None:
    parent_step_id = step['step_id']
    debug(f"=>invoke_step.py {parent_step_id} {' '.join(args)}")
    base_name = os.path.join(step['dir'], f"{parent_step_id}")
    python_executable = 'python' if config['my_os'] == 'win' else 'python3'
    if os.path.exists(f"{base_name}.py"):
        step_script = f"{base_name}.py"
        process = subprocess.run([python_executable, step_script] + args, capture_output=True, text=True)
        print(f"Step {parent_step_id} exited with code {process.returncode}. Output:")
        print(process.stdout)
        return
    
    if os.path.exists(f"{base_name}.pl"):
        step_script = f"{base_name}.pl"
        process = subprocess.run(['perl', step_script] + args, capture_output=True, text=True)
        print(f"Step {parent_step_id} exited with code {process.returncode}. Output:")
        print(process.stdout)
        return
    
    if config['my_os'] == 'win':
        startup_script = os.path.join(config['script_root'], "cli", "ws_run_step.ps1")
        step_script = ( f"{base_name}.ps1")
        if os.path.exists(step_script):
            process = subprocess.run(['pwsh', '-ExecutionPolicy', 'Bypass', '-File', startup_script, step_script, *args])
            print(f"Step {parent_step_id} exited with code {process.returncode}. Output:")
            print(process.stdout)
        return
    
    startup_script = os.path.join(config['script_root'], "cli", "ws_run_step.sh")
    step_script = os.path.join(step['dir'], f"{parent_step_id}.sh")
    if os.path.exists(step_script):
        debug(f"running sub process bash {startup_script} {step_script} {' '.join(args)}")
        # process = subprocess.run(['bash', startup_script, step_script, *args])
        process = subprocess.run(['bash', startup_script, step_script]+ args, capture_output=True, text=True)
        if process.returncode != 0:
            debug(f"=>invoke_step.py: step {parent_step_id} failed with code {process.returncode}. Output:")
            debug(process.stdout)