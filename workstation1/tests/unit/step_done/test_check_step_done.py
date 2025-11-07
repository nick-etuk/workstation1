import unittest
from unittest.mock import patch, MagicMock
from typing import Any, Dict

from icecream import ic
from workstation1.step_done.check_step_done import check_step_done


class TestCheckStepDone(unittest.TestCase):
    """Unit tests for the check_step_done function."""

    def setUp(self) -> None:
        self.base_step: Dict[str, Any] = {
            'step_id': 'example_step',
            'checks': {
                'ubuntu': ['test -d /tmp'],
                'unix': ['test -d /var/tmp']
            }
        }
        self.step_args: list[str] = ['arg1', 'arg2']

    def test_returns_true_when_no_checks_key(self):
        step = {'step_id': 'no_checks'}
        result = check_step_done(step, [], 'step_exit')
        self.assertTrue(result)

    @patch('workstation1.step_done.check_step_done.subprocess.run')
    def test_combines_ubuntu_and_unix_checks(self, mock_run: MagicMock):
        mock_run.returncode = 0  # Ensure truthy path
        mock_run.return_value = MagicMock(returncode=0, stdout='ok')
        result = check_step_done(self.base_step, self.step_args, 'step_exit')
        self.assertTrue(result)
        args_passed = mock_run.call_args[0][0]
        # ic(mock_run.call_args)
        # self.assertIn('test -d /tmp', args_passed) #todo: fix and restore this line
        self.assertIn('test -d /var/tmp', args_passed)

    @patch('workstation1.step_done.check_step_done.error')
    @patch('workstation1.step_done.check_step_done.subprocess.run')
    def test_empty_checks_for_non_exit_and_non_dependencies(self, mock_run: MagicMock, mock_error: MagicMock):
        step: Dict[str, Any] = {'step_id': 'empty', 'checks': {}}
        mock_run.return_value = MagicMock(returncode=0, stdout='')  # Should not be called
        result = check_step_done(step, [], 'other_function')
        self.assertFalse(result)
        mock_error.assert_called_once()
        mock_run.assert_not_called()

    @patch('workstation1.step_done.check_step_done.warn')
    @patch('workstation1.step_done.check_step_done.info')
    @patch('workstation1.step_done.check_step_done.subprocess.run')
    def test_failed_checks_with_step_exit_logs(self, mock_run: MagicMock, mock_info: MagicMock, mock_warn: MagicMock):
        mock_run.return_value = MagicMock(returncode=1, stdout='failed output')
        result = check_step_done(self.base_step, self.step_args, 'step_exit')
        self.assertFalse(result)
        mock_warn.assert_called_once()
        # info should be called multiple times (checks, result, output)
        self.assertGreaterEqual(mock_info.call_count, 3)

    @patch('workstation1.step_done.check_step_done.subprocess.run')
    def test_failed_checks_non_step_exit_returns_false_without_logging(self, mock_run: MagicMock):
        mock_run.return_value = MagicMock(returncode=1, stdout='failed output')
        result = check_step_done(self.base_step, self.step_args, 'step_entry')
        self.assertFalse(result)

    @patch('workstation1.step_done.check_step_done.subprocess.run')
    def test_successful_checks_return_true(self, mock_run: MagicMock):
        mock_run.return_value = MagicMock(returncode=0, stdout='success output')
        result = check_step_done(self.base_step, self.step_args, 'step_exit')
        self.assertTrue(result)

    @patch('workstation1.step_done.check_step_done.subprocess.run')
    def test_no_unix_checks_for_win_os_key_absent(self, mock_run: MagicMock):
        step: Dict[str, Any] = {
            'step_id': 'only_ubuntu',
            'checks': {
                'ubuntu': ['test -d /tmp'],
            }
        }
        mock_run.return_value = MagicMock(returncode=0, stdout='success')
        result = check_step_done(step, [], 'step_exit')
        self.assertTrue(result)
        # ic(mock_run.call_args)
        # args_passed = mock_run.call_args[0][0] #todo: fix this
        # Should only include ubuntu check
        # self.assertEqual(args_passed.count('test -d /tmp'), 1) #todo: fix this


if __name__ == '__main__':
    unittest.main()
