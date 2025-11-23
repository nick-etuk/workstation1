
import os
import pathlib
from typing import Any
from workstation1.registry.add_project.detect_python import detect_python_project, extract_description_python
from workstation1.registry.get_registries import get_registries
from workstation1.registry.write_registry import write_registry
from workstation1.registry.update_step_registry import update_step_registry
from workstation1.lib.logging import info

def add_project(args: list[str]) -> None:

    detect_language = {
        'python': detect_python_project,
    }

    extract_description = {
        'python': extract_description_python,
    }

    languages = ['python']  # Extendable for other languages in the future


    current_path = os.getcwd()
    # current_path = str(pathlib.Path().resolve())

    for lang in languages:
        if detect_language[lang](current_path):
            info(f"Detected {lang} project at {current_path}")
            description = extract_description[lang](current_path)
            info(f"Project description: {description}")

            project_registry, _ = get_registries()

            project_id = pathlib.Path(current_path).name
            new_project_entry: dict[str, Any] = {
                'project_id': project_id,
                'path': current_path,
                'title': description if description else project_id,
            }

            if any(proj['project_id'] == project_id for proj in project_registry):
                info(f"Project {project_id} already exists in the registry.")
                return

            project_registry.append(new_project_entry)
            write_registry(project_registry, 'project')
            info(f"Added project {project_id} to registry.")

            update_step_registry(project_registry)
            return

