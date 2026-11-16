"""Preflight for Flutter debug launches on macOS. Use --dry-run to inspect."""
import argparse
import os
from pathlib import Path
import signal
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
MARK = "FUNDEX_IOS_DEBUG_LAUNCH=1"


def output(args):
    result = subprocess.run(args, capture_output=True, text=True,
                            errors="replace", env={**os.environ, "LC_ALL": "C"})
    return result.stdout.strip() if result.returncode == 0 else ""


def snapshot(pid=None):
    selection = ["-p", str(pid)] if pid else ["-U", str(os.getuid())]
    rows = output(["/bin/ps", "-ww", *selection, "-o", "uid=,pid=,ppid=,lstart=,comm="])
    processes = {}
    for row in rows.splitlines():
        fields = row.split(None, 8)
        if len(fields) == 9 and int(fields[0]) == os.getuid():
            processes[int(fields[1])] = (int(fields[2]), tuple(fields[3:8]), fields[8])
    return processes


def working_directories(pid):
    listing = output(["/usr/sbin/lsof", "-a", "-p", str(pid), "-d", "cwd", "-Fn"])
    return [Path(line[1:]).resolve() for line in listing.splitlines()
            if line.startswith("n/")]


def eligible(pid, process):
    parent, _, executable = process
    if parent != 1:
        return False
    if executable.endswith("/Contents/Developer/usr/bin/lldb"):
        debugger = "lldb"
    elif "/CoreDevice.framework/" in executable and executable.endswith("/bin/devicectl"):
        debugger = "devicectl"
    else:
        return False
    if ROOT not in working_directories(pid):
        return False

    cmd = output(["/bin/ps", "-ww", "-p", str(pid), "-o", "command="])
    if debugger == "lldb" and cmd != executable:
        return False
    if debugger == "devicectl":
        if not cmd.startswith(executable + " "):
            return False
        args = cmd[len(executable):].split()
        if (args[:3] != ["device", "process", "launch"] or
                not {"--start-stopped", "--console", "com.fund.stellavia",
                     "--enable-dart-profiling"}.issubset(args)):
            return False

    # macOS ps prints argv followed by the inherited environment. Read only the
    # suffix and never print it (other environment values may be sensitive).
    env = output(["/bin/ps", "eww", "-p", str(pid), "-o", "command="])
    return bool(cmd and env.startswith(cmd + " ") and
                MARK in env[len(cmd):].split())


def project_run_may_be_active():
    rows = output(["/bin/ps", "-ww", "-U", str(os.getuid()), "-o", "pid=,command="])
    if not rows:
        return True
    for row in rows.splitlines():
        pid, command = row.split(None, 1)
        if "flutter_tools.snapshot" not in command:
            continue
        # Includes F5 (flutter run --machine) and terminal runs. If the cwd
        # cannot be read, assume the run might belong to this checkout.
        args = command.split("flutter_tools.snapshot", 1)[1].split()
        if "run" in args or "attach" in args:
            paths = working_directories(pid)
            if not paths or ROOT in paths:
                return True
    return False


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    if sys.platform != "darwin":
        return
    if project_run_may_be_active():
        print("iOS preflight: existing Flutter session, skipping cleanup")
        return
    count = 0
    for pid, identity in snapshot().items():
        if not eligible(pid, identity):
            continue
        # Recheck the start time, parent and executable immediately before TERM.
        if snapshot(pid).get(pid) != identity:
            continue
        if not args.dry_run:
            try:
                os.kill(pid, signal.SIGTERM)
            except ProcessLookupError:
                continue
        count += 1
        action = "would terminate" if args.dry_run else "sent TERM to"
        print(f"iOS preflight: {action} orphan {Path(identity[2]).name} (PID {pid})")
    if not count:
        print("iOS preflight: no verified stale project debugger found")


if __name__ == "__main__":
    main()
