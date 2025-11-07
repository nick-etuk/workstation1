import unittest
from unittest.mock import patch, MagicMock
from io import StringIO
from typing import Any, Dict, List

from workstation1.lib.config import config
from workstation1.run_step.run_activity import run_activity


class TestRunActivityIntegration(unittest.TestCase):
    """Integration test for run_activity invoking multiple steps via run_step/execute_step."""

    def setUp(self) -> None:
        # Sample activity with two steps (second has an argument)
        self.activity_path = '/tmp/activity.json'
        self.activity_json = '{"steps": ["stepA arg1", "stepB"]}'
        self.activity: Dict[str, Any] = {'path': self.activity_path,
                         'steps': ["stepA arg1", "stepB"]}

        # Simulated step registry CSV; run_step will open this path
        self.step_registry_path = f"{config['working_dir']}/step_registry.csv"
        self.step_registry_csv = (
            'step_id,sort_order,description,path\n'
            'stepA,1,Step A,/tmp/steps/stepA/config.json\n'
            'stepB,2,Step B,/tmp/steps/stepB/config.json\n'
        )
        self.step_registry: List[Dict[str, str]] = [
            {'step_id': 'stepA', 'sort_order': '1', 'description': 'Step A', 'path': '/tmp/steps/stepA/config.json'},
            {'step_id': 'stepB', 'sort_order': '2', 'description': 'Step B', 'path': '/tmp/steps/stepB/config.json'},
        ]

        # Each step's config JSON file (minimal valid JSON)
        self.stepA_config_path = '/tmp/steps/stepA/config.json'
        self.stepB_config_path = '/tmp/steps/stepB/config.json'
        self.empty_config_json = '{}'

    def _open_side_effect(self, filename: str, *args: Any, **kwargs: Any):
        # Provide content based on the requested filename
        if filename == self.activity_path:
            return StringIO(self.activity_json)
        if filename == self.step_registry_path:
            return StringIO(self.step_registry_csv)
        if filename == self.stepA_config_path:
            return StringIO(self.empty_config_json)
        if filename == self.stepB_config_path:
            return StringIO(self.empty_config_json)
        # Fallback generic mock file
        return StringIO('')

    @patch('workstation1.run_step.execute_step.step_exit', return_value=True)
    @patch('workstation1.run_step.execute_step.step_entry', return_value=True)
    @patch('builtins.print')
    @patch('subprocess.run')
    @patch('builtins.open')
    def test_activity_invokes_both_steps_in_order(self, mock_open_fn: MagicMock, mock_subprocess_run: MagicMock, mock_print: MagicMock, mock_step_entry: MagicMock, mock_step_exit: MagicMock):
        # Configure open side effects to serve activity, registry, and config files
        mock_open_fn.side_effect = self._open_side_effect

        # Mock subprocess to simulate successful execution for each step
        mock_subprocess_run.return_value = MagicMock(returncode=0, stdout='ok')

        run_activity(activity=self.activity, step_registry=self.step_registry)

        # subprocess.run should have been called twice (once per step)
        self.assertEqual(mock_subprocess_run.call_count, 2)

        # Extract script paths used in each call for verification
        called_script_paths: list[str] = []
        for call in mock_subprocess_run.call_args_list:
            args = call[0][0]  # first positional argument list passed to subprocess.run
            # Expect structure: ['bash', startup_script, step_script, *args]
            self.assertGreaterEqual(len(args), 3)
            step_script = args[2]
            called_script_paths.append(step_script)

        self.assertIn('/tmp/steps/stepA/stepA.sh', called_script_paths)
        self.assertIn('/tmp/steps/stepB/stepB.sh', called_script_paths)

        # Confirm ordering: first call corresponds to stepA then stepB due to sort_order
        self.assertTrue(called_script_paths[0].endswith('stepA.sh'))
        self.assertTrue(called_script_paths[1].endswith('stepB.sh'))

        # Ensure argument forwarding: stepA had an arg 'arg1'
        first_call_args = mock_subprocess_run.call_args_list[0][0][0]
        self.assertIn('arg1', first_call_args)


if __name__ == '__main__':
    unittest.main()
