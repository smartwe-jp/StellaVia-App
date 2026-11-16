import unittest
from unittest.mock import patch

import ios_debug_cleanup as cleanup


class CleanupTests(unittest.TestCase):
    lldb = "/Applications/Xcode.app/Contents/Developer/usr/bin/lldb"
    device = "/Library/Developer/PrivateFrameworks/CoreDevice.framework/Versions/A/bin/devicectl"
    launch = " device process launch --start-stopped --console com.fund.stellavia --enable-dart-profiling"

    def check(self, executable, args="", parent=1, marked=True, project=True):
        command = executable + args
        environment = command + (" " + cleanup.MARK if marked else " OTHER=1")
        with patch.object(cleanup, "working_directories", return_value=[cleanup.ROOT] if project else []), \
             patch.object(cleanup, "output", side_effect=[command, environment]):
            return cleanup.eligible(123, (parent, (), executable))

    def test_only_marked_orphans_in_checkout(self):
        for executable, args in [(self.lldb, ""), (self.device, self.launch)]:
            self.assertTrue(self.check(executable, args))
            self.assertFalse(self.check(executable, args, parent=555))
            self.assertFalse(self.check(executable, args, marked=False))
            self.assertFalse(self.check(executable, args, project=False))
        self.assertFalse(self.check(self.device, " device install app"))
        self.assertFalse(self.check(self.device, self.launch.replace("com.fund.stellavia", "other")))
        self.assertFalse(self.check(self.lldb, " /tmp/another-app"))

    def test_no_signal_for_active_session_dry_run_or_reused_pid(self):
        first = (1, ("old",), self.lldb)
        for active, dry, second in [(True, False, first), (False, True, first),
                                    (False, False, (1, ("new",), self.lldb))]:
            with patch.object(cleanup.sys, "platform", "darwin"), \
                 patch.object(cleanup.sys, "argv", ["check"] + (["--dry-run"] if dry else [])), \
                 patch.object(cleanup, "project_run_may_be_active", return_value=active), \
                 patch.object(cleanup, "snapshot", side_effect=[{123: first}, {123: second}]), \
                 patch.object(cleanup, "eligible", return_value=True), \
                 patch.object(cleanup.os, "kill") as kill:
                cleanup.main()
                kill.assert_not_called()


if __name__ == "__main__":
    unittest.main()
