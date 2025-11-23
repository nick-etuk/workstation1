from workstation1.lib.logging import info
from workstation1.registry.get_registries import get_registries

# from icecream import ic

def list_steps(args: list[str]) -> None:
    project_registry, step_registry = get_registries()

    info("core")
    core_steps = [step for step in step_registry if step['project_id'] == 'core']
    core_steps = sorted(core_steps, key=lambda x: x['step_id'])
    for step in core_steps:
        info(f"\t {step['step_id']}")

    for project in project_registry:
        info(f"{project['title']}")
        project_steps = [step for step in step_registry if step['project_id'] == project['project_id']]
        project_steps = sorted(project_steps, key=lambda x: x['step_id'])
        for step in project_steps:
            info(f"\t {step['step_id']}")
    return
 