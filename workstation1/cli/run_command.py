# from workstation1.menu.menu_main import get_activities
from typing import Any
from workstation1.run_step.run_step import run_step
from workstation1.registry.update_registries import update_registries
# from icecream import ic

def run_command(project_registry: list[dict[str, Any]], step_registry: list[dict[str, Any]], args: list[str], new_tab_active: bool = False):
    command = args[0]
    command_args = args[1:]

    if command == 'scan':
        update_registries(project_registry)
        return
    
    if command == "list":
        print("core")
        core_steps = [step for step in step_registry if step['project_id'] == 'core']
        core_steps = sorted(core_steps, key=lambda x: x['step_id'])
        for step in core_steps:
            print(f"\t {step['step_id']}")

        for project in project_registry:
            print(f"{project['project_id']} {project['title']}")
            project_steps = [step for step in step_registry if step['project_id'] == project['project_id']]
            project_steps = sorted(project_steps, key=lambda x: x['step_id'])
            for step in project_steps:
                print(f"\t {step['step_id']}")
        return
        
    for step in step_registry:
        if step['step_id'] == command or step['short_name'] == command:
            run_step(step_registry_entry=step, step_args=command_args, new_tab_active=new_tab_active)