from typing import Any
import subprocess
from workstation1.lib.config import config
from workstation1.lib.logging import debug


def invoke_commands(commands: list[str]) -> bool:
    if config['my_os'] == 'win':
        startup_script = f"{config['script_root']}/cli/ws_run_commands.ps1"
        process = subprocess.run(
            ['pwsh', '-ExecutionPolicy', 'Bypass', '-File', startup_script] + commands,
            capture_output=True,
            text=True)
    else:
        startup_script = f"{config['script_root']}/cli/ws_run_commands.sh"
        process = subprocess.run(
            ['bash', startup_script] + commands,
            capture_output=True,
            text=True)
    
    if process.returncode != 0:
        debug(f"commands: {','.join(commands)}")
        debug(f"Result: {process.returncode}")
        debug(f"output: {process.stdout}")
        return False
    
    return True


def invoke_step_commands(step: dict[str, Any]) -> bool:
    if 'commands' not in step:
        return True
    
    return invoke_commands(step['commands'])
