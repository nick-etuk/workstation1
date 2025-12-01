import json
from workstation1.run_step.run_step import run_step

def run_activity(activity: dict[str, Any], step_registry: list[dict[str, Any]] = []):
    with open(activity['path']) as f:
        activity = json.load(f)
        steps = activity['steps']
        for raw_step in steps:
            # split raw step string by '~' to get step id and args
            # step_parts = raw_step.split('~')
            step_parts = raw_step.split(' ')
            step_id = step_parts[0]
            step_args: list[str] = step_parts[1:] if len(step_parts) > 1 else []
            matched_steps = [step for step in step_registry if step['step_id'] == step_id]
            if not matched_steps:
                print(f"Step {step_id} not found in step registry.")
                continue
            if len(matched_steps) > 1:
                print(f"Warning: Multiple entries found for step {step_id}. Using the first match.")
            run_step(step_registry_entry=matched_steps[0], step_args=step_args)
