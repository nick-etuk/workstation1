import os
import subprocess

from workstation1.lib.config import config


def open_new_tab():
    my_env = os.environ.copy()
    # my_env["WS_ROOT_UNIX"] = f"/usr/sbin:/sbin:{my_env['PATH']}"
    # subprocess.Popen(my_command, env=my_env)
    # $(find "$WS_ROOT_UNIX/core" -name "ws.sh" -type f)
    # startup_script = '/home/account1/repos/workstation1/src/core/cli/run_step.sh'
    # startup_script = 'python3 /home/account1/repos/workstation1/workstation1/ws.py'
    startup_script = f"{config['ws_root_unix']}/ws.sh"
    if config['vm'] == 'wsl':
        # run wt.exe to open a new tab in Windows Terminal
        # subprocess.Popen(['wt.exe', 'bash', '-c', 'python3 /home/account1/repos/workstation1/workstation1/ws.py'])
        # subprocess.call(['wt.exe', '-w', '0', 'nt', '--colorScheme', 'Campbell Powershell', '--title', 'Workstation1', '-p', 'Ubuntu', 'bash', '-c', startup_script], shell=True)
        subprocess.call(['wt.exe', '-w', '0', 'nt', '--colorScheme', 'Campbell Powershell', '--title', 'Workstation1', '-p', 'Ubuntu', 'bash', '-c', startup_script], env=my_env)
        return
    
    if config['my_os'] in ['ubuntu', 'macos']:
        # subprocess.Popen(['ttab',  startup_script])
        subprocess.call(['ttab',  startup_script], shell=True)