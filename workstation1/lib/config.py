import os
from pathlib import Path
from typing import Any
from workstation1.lib.detect_os import detect_os
from definitions import python_root

# from icecream import ic

home_dir = Path.home()
my_os, vm = detect_os()

static_config: dict[str, Any] = {
    'base_dir_name': '.workstation1',
    'working_dir_name': 'working',
    'new_tab_dir_name': 'new_tab_queue',
    'debug': True,
    }

ws_root = Path(python_root).parent
computed_config: dict[str, Any] = {
    'ws_root': str(ws_root),
    'python_root': python_root,
    'script_root': str(ws_root / 'src' / 'core'),
    'my_os': my_os,
    'vm': vm,
    'working_dir': str(home_dir / static_config['base_dir_name'] / static_config['working_dir_name']),
    'new_tab_dir': str(home_dir / static_config['base_dir_name'] / static_config['working_dir_name'] / static_config['new_tab_dir_name']),
    'log_base': str(home_dir / static_config['base_dir_name'] / 'log'),
    'my_download_dir': str(home_dir / static_config['base_dir_name'] / 'downloads'),
}

config = {**static_config, **computed_config}
if not os.path.exists(config['new_tab_dir']):
    os.makedirs(config['new_tab_dir'], exist_ok=True)

# todo: project dependent configuration. move these out of core.
android_emulator_port = '5554'
loginenv = 'sandpit'

node_major_version = '22'
dotnet_major_version = '8'
python_major_version = '3.10'
    