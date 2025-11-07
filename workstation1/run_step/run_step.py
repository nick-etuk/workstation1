from workstation1.run_step.execute_step import execute_step
# from icecream import ic


def run_step(step: dict[str, str], step_args: list[str], new_tab_active: bool = False):
    execute_step(parent_registry_entry=step, parent_step_args=step_args, new_tab_active=new_tab_active)
