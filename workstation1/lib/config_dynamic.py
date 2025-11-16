import os
from workstation1.lib.config import config


def get_dynamic(key:str, group: str='general') -> str|None:
    """Get a dynamic configuration value from the filesystem."""
    
    if not os.path.isdir(f"{config['working_dir']}/{group}"):
        return None

    status_file = f"{config['working_dir']}/{group}/{key}.txt"
    if not os.path.isfile(status_file):
        return None
    with open(status_file) as f:
        value = f.read().strip()
    return value


def set_dynamic(key:str, group: str='general', value: str='', ) -> None:
    """Set a dynamic configuration value on the filesystem."""
    
    current_value = get_dynamic(key=key, group=group)
    if current_value == value:
        return
    
    if not os.path.isdir(f"{config['working_dir']}/{group}"):
        os.makedirs(f"{config['working_dir']}/{group}")

    status_file = f"{config['working_dir']}/{group}/{key}.txt"
    with open(status_file, "w") as f:
        f.write(value)