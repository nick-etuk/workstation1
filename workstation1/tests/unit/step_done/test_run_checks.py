import unittest
import subprocess

from workstation1.lib.config import config
# from icecream import ic

class TestRunChecks(unittest.TestCase):

    def test_multiple_checks_all_pass(self):
        startup_script = f"{config['script_root']}/cli/ws_run_checks.sh"
        process = subprocess.run(
            ['bash', startup_script, 'test -d /tmp', 'test -d /var/tmp'],
            capture_output=True,
            text=True)
        ret_code = process.returncode
        self.assertEqual(ret_code, 0)
        # ic(process)

    def test_multiple_checks_last_one_fails(self):
        startup_script = f"{config['script_root']}/cli/ws_run_checks.sh"
        process = subprocess.run(
            ['bash', startup_script, 'test -d /tmp', 'test -d /tmp1'],
            capture_output=True,
            text=True)
        ret_code = process.returncode
        self.assertEqual(ret_code, 1)
        # ic(process)


if __name__ == '__main__':
    unittest.main()