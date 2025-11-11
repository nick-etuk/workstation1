import sys
from workstation1.registry.get_registries import get_registries
from workstation1.menu.menu_main import show_menu_main
from workstation1.cli.run_command import run_command
# from workstation1.lib.get_new_tab_file import get_new_tab_file

# from icecream import ic

def main():
    project_registry, step_registry = get_registries()

    # new_tab_file = get_new_tab_file()
    # if new_tab_file:
    #     print(f"=>ws.py file found in new_tab queue: {new_tab_file}")
    #     with open(new_tab_file) as f:
    #         content = f.readlines()
    #     os.remove(new_tab_file)
        
    #     for line in content:
    #         print(f"line: {line}")
    #         commands = line.split('~')
    #         run_command(project_registry=project_registry, step_registry=step_registry, args=commands, new_tab_active=True)
    #     return
    
    commands = sys.argv[1:]
    if not commands or all(cmd.strip() == '' for cmd in commands):
            show_menu_main(project_registry=project_registry, step_registry=step_registry)
            sys.exit(0)

    run_command(project_registry=project_registry, step_registry=step_registry, args=commands)

if __name__ == "__main__":
    main()