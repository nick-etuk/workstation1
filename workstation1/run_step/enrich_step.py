from typing import Any, Dict

def enrich_step(config: Dict[str, Any], registry_entry: Dict[str, Any]) -> Dict[str, Any]:
    enriched_config = config.copy()
    enriched_config['step_id'] = registry_entry['step_id']
    enriched_config['description'] = registry_entry['description']
    enriched_config['path'] = registry_entry['path']
    step_dir = registry_entry['path'].rsplit('/', 1)[0]
    enriched_config['dir'] = step_dir
    return enriched_config
