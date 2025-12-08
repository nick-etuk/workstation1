from workstation1.lib.config import config
from workstation1.lib.config_dynamic import get_dynamic

def show_config() -> None:
    excluded = [
        'base_dir_name', 
        'working_dir_name', 
        'new_tab_dir_name', 
        'new_tab_dir', 
        'log_dir', 
        'log_base', 
        'temp_dir', 
        'python_root', 
        'my_download_dir',
        'debug']
    for key, value in config.items():
        if key not in excluded:
            print(f"{key}:{' ' * (25 - len(key))}{value}")


    dynamic_config = {
        'current_project_id': get_dynamic('current_project_id'),
        'current_project_root': get_dynamic('current_project_root')
    }
    for key, value in dynamic_config.items():
        print(f"{key}:{' ' * (25 - len(key))}{value}")