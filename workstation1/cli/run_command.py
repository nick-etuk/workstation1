from workstation1.menu.menu_main import get_activities
from workstation1.run_step.run_activity import run_activity
from workstation1.run_step.run_step import run_step
# from icecream import ic

def run_command(activity_registry: list[dict[str, str]], step_registry: list[dict[str, str]], args: list[str], new_tab_active: bool = False):
    command = args[0]
    command_args = args[1:]

    if command == "list_activities":
        if not command_args:
            print("Please provide a project ID to list activities.")
            return
        project_id = command_args[0]
        activities = get_activities(activity_registry, project_id)
        for activity in activities:
            print(f"\t ws {activity['activity_id']} \t {activity['title']}")
        return

    for activity in activity_registry:
        if activity['activity_id'] == command:
            run_activity(activity=activity, step_registry=step_registry)
        
    for step in step_registry:
        if step['step_id'] == command:
            run_step(step=step, step_args=command_args, new_tab_active=new_tab_active)