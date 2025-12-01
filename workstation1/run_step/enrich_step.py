from typing import Any

# from icecream import ic

def enrich_step(base_step: dict[str, Any], registry_entry: dict[str, Any]) -> dict[str, Any]:
    enriched_step = base_step.copy()
    enriched_step['step_id'] = registry_entry['step_id']
    enriched_step['title'] = registry_entry['title']
    enriched_step['base_filename'] = registry_entry['base_filename']
    enriched_step['path'] = registry_entry['path']
    return enriched_step
