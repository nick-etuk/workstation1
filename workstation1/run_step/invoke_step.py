
from typing import Any
import os
import subprocess
from workstation1.lib.config import config
from workstation1.lib.logging import debug
# from icecream import ic


def invoke_step(step: dict[str, Any], args: list[str]) -> None:
    parent_step_id = step['step_id']
    
    if args and len(args) > 0:
        debug(f"Running step {parent_step_id} with args: {args}")
    else:
        debug(f"Running step {parent_step_id}")
    
    base_filename = os.path.join(step['path'], f"{step['base_filename']}")
    python_executable = 'python' if config['my_os'] == 'win' else 'python3'
    if os.path.exists(f"{base_filename}.py"):
        step_script = f"{base_filename}.py"
        process = subprocess.run([python_executable, step_script] + args, capture_output=True, text=True)
        print(f"Step {parent_step_id} exited with code {process.returncode}. Output:")
        print(process.stdout)
        return
    
    if os.path.exists(f"{base_filename}.pl"):
        step_script = f"{base_filename}.pl"
        process = subprocess.run(['perl', step_script] + args, capture_output=True, text=True)
        print(f"Step {parent_step_id} exited with code {process.returncode}. Output:")
        print(process.stdout)
        return
    
    if config['my_os'] == 'win':
        startup_script = os.path.join(config['script_root'], "cli", "ws_run_step_script.ps1")
        step_script = f"{base_filename}.ps1"
        debug(f"running sub process pwsh {startup_script} {step_script} {' '.join(args)}")
        if os.path.exists(step_script):
            # process = subprocess.run(['pwsh', '-ExecutionPolicy', 'Bypass', '-File', startup_script, step_script, *args])
            process = subprocess.run(['pwsh', '-ExecutionPolicy', 'Unrestricted', '-File', startup_script, step_script, *args])
            print(f"Step {parent_step_id} exited with code {process.returncode}. Output:")
            print(process.stdout)
        return
    
    startup_script = os.path.join(config['script_root'], "cli", "ws_run_step_script.sh")
    step_script = f"{base_filename}.sh"
    if os.path.exists(step_script):
        debug(f"invoke_step running script {step_script} {' '.join(args)}")
        # process = subprocess.run(['bash', startup_script, step_script, *args])
        process = subprocess.run(['bash', startup_script, step_script]+ args, capture_output=True, text=True)
        if process.returncode != 0:
            debug(f"=>invoke_step.py: step {parent_step_id} failed with code {process.returncode}. Output:")
            debug(process.stdout)