# import csv
from menu.get_activities import get_activities
# from icecream import ic

def show_menu_main(project_registry: list[dict[str, str]], activity_registry: list[dict[str, str]]) -> None :
    print("\n\t Welcome to Workstation1\n\n")

    for project in project_registry:
        border = "-" * len(project['title'])
        print(f"\t {border}")
        print(f"\t {project['title']}")
        print(f"\t {border}")
        activities = get_activities(activity_registry, project['project_id'])
        for activity in activities:
            print(f"\t ws {activity['activity_id']} \t {activity['title']}")
        print("\n")
