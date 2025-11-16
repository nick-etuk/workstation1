from pathlib import Path
from typing import Any

# from icecream import ic

def enrich_step(base_step: dict[str, Any], registry_entry: dict[str, Any]) -> dict[str, Any]:
    enriched_config = base_step.copy()
    enriched_config['step_id'] = registry_entry['step_id']
    enriched_config['title'] = registry_entry['title']
    enriched_config['path'] = registry_entry['path']
    config_file = Path(registry_entry['path'])
    step_dir = str(config_file.parent)
    enriched_config['dir'] = step_dir
    return enriched_config
