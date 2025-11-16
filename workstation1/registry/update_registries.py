from typing import Any

from workstation1.registry.update_step_registry import update_step_registry

def update_registries(project_registry: list[dict[str, Any]]) -> None:
    update_step_registry(project_registry)