def get_activities(activity_registry: list[dict[str, str]], project_id: str) -> list[dict[str, str]]:
    activities = [activity for activity in activity_registry if activity['project_id'] == project_id]
    return activities
