import os
import subprocess
from workstation1.lib.config import config
from workstation1.lib.logging import debug

# from icecream import ic

def open_new_tab():
    my_env = os.environ.copy()
    # my_env["ws_root"] = f"/usr/sbin:/sbin:{my_env['PATH']}"
    # subprocess.Popen(my_command, env=my_env)
    # $(find "$ws_root/core" -name "ws1.sh" -type f)
    # startup_script = '/home/account1/repos/workstation1/src/core/cli/run_step.sh'
    # startup_script = 'python3 /home/account1/repos/workstation1/workstation1/ws.py'
    if config['my_os'] == 'win':
        startup_script = f"{config['ws_root']}\\ws1.ps1"
        # subprocess.call(['wt.exe', '-window', '0', 'nt', '--colorScheme', 'Campbell Powershell', '--title', 'Workstation1', '--profile', 'PowerShell', startup_script])
        # subprocess.call(['wt.exe', 'profile', 'PowerShell', startup_script])
        # subprocess.call(['wt.exe', 'profile', 'PowerShell'])
        # subprocess.call(['wt', 'new-tab', 'pwsh', '-NoLogo', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', startup_script], env=my_env)
        # subprocess.call(['wt', 'new-tab', 'pwsh', '-NoExit', '-ExecutionPolicy', 'Bypass', '-File', startup_script])
        subprocess.run(['wt', 'new-tab', 'pwsh', '-NoExit', '-File', startup_script])
        return
    if config['vm'] == 'wsl':
        startup_script = f"{config['ws_root']}/ws1.sh"
        debug(f"WSL detected, opening new Windows Terminal tab with script: {startup_script}")
        return
        subprocess.run(['wt', '-w', '0', 'nt', '--colorScheme', 'Campbell Powershell', '--title', 'Workstation1', '-p', 'Ubuntu', 'bash', '-c', startup_script], env=my_env)
        return
    
    if config['my_os'] in ['ubuntu', 'macos']:
        startup_script = f"{config['ws_root']}/ws1.sh"
        # subprocess.Popen(['ttab',  startup_script])
        # subprocess.call(['ttab',  startup_script], shell=True)
        subprocess.run(['ttab'], shell=True)