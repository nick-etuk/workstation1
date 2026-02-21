import os
import sys

from workstation1.lib.show_config import show_config
from workstation1.registry.get_registries import get_registries
from workstation1.menu.menu_main import show_menu_main
from workstation1.cli.cli_command import cli_command
from workstation1.lib.get_new_tab_file import get_new_tab_file
from workstation1.run_step.run_step import run_step

from icecream import ic

def main():
    new_tab_file = get_new_tab_file()
    if not new_tab_file:
        commands = sys.argv[1:]
        if commands and any(c.strip() != '' for c in commands):
            print(f"Commands: {commands}")
            cli_command(args=commands)
            sys.exit(0)


    project_registry, step_registry = get_registries()         

    if new_tab_file:
        print(f"Entry found in new_tab queue: {new_tab_file}")
        with open(new_tab_file) as f:
            content = f.readlines()
        os.remove(new_tab_file)
        
        for line in content:
            line = line.strip()
            print(f"line:>{line}<")
            parts = line.split('~')
            step_id = parts[0]
            args = parts[1:]
            ic(args)

            for step in step_registry:
                if step['step_id'] == step_id:
                    run_step(step_registry_entry=step, step_args=args, overrides=[], new_tab_active=True)
                    break
        # return
        sys.exit(0)
    
    show_config()
    show_menu_main(project_registry=project_registry, step_registry=step_registry)
    sys.exit(0)


if __name__ == "__main__":
    main()