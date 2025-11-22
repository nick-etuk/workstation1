from pathlib import Path
from typing import Any

# from icecream import ic

def enrich_step(base_step: dict[str, Any], registry_entry: dict[str, Any]) -> dict[str, Any]:
    enriched_step = base_step.copy()
    enriched_step['step_id'] = registry_entry['step_id']
    enriched_step['title'] = registry_entry['title']
    enriched_step['path'] = registry_entry['path']
    config_file = Path(registry_entry['path'])
    step_dir = str(config_file.parent)
    enriched_step['dir'] = step_dir
    enriched_step['exitTo'] = base_step.get('exit_to_path', '')
    return enriched_step
