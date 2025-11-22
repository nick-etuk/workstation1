import os
from workstation1.cli.set_exit_path import set_exit_path
from workstation1.lib.config import config
from workstation1.lib.logging import info
from workstation1.lib.config_dynamic import get_dynamic, set_dynamic
from workstation1.registry.get_registries import get_registries
from workstation1.run_step.run_step import run_step
from workstation1.registry.update_registries import update_registries
# from icecream import ic

def cli_command(args: list[str], new_tab_active: bool = False):
    command = args[0]
    command_args = args[1:]

    if command == 'scan':
        project_registry, _ = get_registries()
        update_registries(project_registry)
        return
    
    if command == "list":
        project_registry, step_registry = get_registries()

        info("core")
        core_steps = [step for step in step_registry if step['project_id'] == 'core']
        core_steps = sorted(core_steps, key=lambda x: x['step_id'])
        for step in core_steps:
            info(f"\t {step['step_id']}")

        for project in project_registry:
            info(f"{project['project_id']} {project['title']}")
            project_steps = [step for step in step_registry if step['project_id'] == project['project_id']]
            project_steps = sorted(project_steps, key=lambda x: x['step_id'])
            for step in project_steps:
                info(f"\t {step['step_id']}")
        return
    
    if command == 'get':
        if len(command_args) < 1:
            # get all dynamic configs
            dynamic_dir = os.path.join(config['working_dir'], 'dynamic_config')
            if not os.path.isdir(dynamic_dir):
                info("No dynamic configuration set.")
                return
            for group in os.listdir(dynamic_dir):
                group_dir = os.path.join(dynamic_dir, group)
                if not os.path.isdir(group_dir):
                    continue
                for filename in os.listdir(group_dir):
                    if not filename.endswith('.txt'):
                        continue
                    key = filename[:-4]
                    value = get_dynamic(key=key, group=group)
                    if group == 'general':
                        info(f"{key} is {value}")
                    else:
                        info(f"[{group}] {key} is {value}")
            return
        key = command_args[0]
        group = command_args[1] if len(command_args) > 1 else 'general'
        value = get_dynamic(key=key, group=group)
        if value is not None:
            if group == 'general':
                info(f"{key} is {value}")
            else:
                info(f"[{group}] {key} is {value}")
        else:
            info(f"{key} is not set")
        return
    
    if command == 'set':
        key = command_args[0]
        value = command_args[1]
        group = command_args[2] if len(command_args) > 2 else 'general'
        set_dynamic(key=key, value=value, group=group)
        if group == 'general':
            info(f"{key} set to {value}")
        else:
            info(f"[{group}] {key} set to {value}")
        return
        
    project_registry, step_registry = get_registries()
    for step in step_registry:
        if step['step_id'] == command:
            set_exit_path(project_registry=project_registry, step_registry_entry=step)
            # run_step(step_registry_entry=step, step_args=command_args, new_tab_active=new_tab_active)