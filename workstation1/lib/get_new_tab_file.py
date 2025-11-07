import os
from workstation1.lib.config import config

def get_new_tab_file() -> str | None:
    new_tab_queue_dir = f"{config['working_dir']}/new_tab_queue"
    if not os.path.exists(new_tab_queue_dir):
        os.makedirs(new_tab_queue_dir)
        return None
    
    list_of_files = os.listdir(new_tab_queue_dir)
    if len(list_of_files) == 0:
        return None

    oldest_file = sorted(list_of_files, key=lambda x: os.path.getctime(os.path.join(new_tab_queue_dir, x)))[0]
    return os.path.join(new_tab_queue_dir, oldest_file)

