import os
import subprocess
from workstation1.lib.config import config
from workstation1.lib.logging import debug

# from icecream import ic

def open_new_tab():
    my_env = os.environ.copy()

    if config['my_os'] == 'win':
        # startup_script = os.path.join(config['ws_root'], 'ws1.ps1')
        # subprocess.run(['wt', 'new-tab', 'pwsh', '-NoExit', '-File', startup_script])
        subprocess.run(['wt.exe', '-w', '0','new-tab', 'pwsh', '-NoExit'])
        return
    
    # startup_script = os.path.join(config['ws_root'], 'ws1.sh')
    if config['vm'] == 'wsl':
        debug("WSL detected, opening new Windows Terminal tab with script")
        subprocess.run(['wt.exe', '-w', '0', 'new-tab', '--colorScheme', 'Campbell Powershell', '--title', 'Workstation1', '-p', 'Ubuntu'], env=my_env)
        return
    
    if config['my_os'] in ['ubuntu', 'macos']:
        subprocess.run(['ttab'], shell=True)