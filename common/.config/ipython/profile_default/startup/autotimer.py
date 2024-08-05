# When on ipython console register a timer that shows the execution time of cells on Ipython
# Similar to: https://pypi.org/project/jupyterlab-execute-time/ just for ipython
#
# https://stackoverflow.com/questions/15411967/how-can-i-check-if-code-is-executed-in-the-ipython-notebook
# https://github.com/cpcloud/ipython-autotime/blob/5aacf36b4de1c4ba5fa46e077b627817b65ff53a/autotime/__init__.py
#
import shlex as _shlex
import shutil as _shutil
import subprocess as _subprocess
from time import monotonic as _monotonic

from IPython.core.magics.execution import _format_time


def _notify(title, msg):
    if _shutil.which('ntfy'):
        _subprocess.run(_shlex.split(f"ntfy send '{title}: {msg}'"))
    elif _shutil.which('ninfo'):
        _subprocess.run(_shlex.split(f"ninfo {title}: {msg}"))
    elif _shutil.which('osascript'):
        _subprocess.run(_shlex.split(f"osascript -e 'display notification \"{msg}\" with title \"{title}\"'"))


class _IpythonAutoTimer(object):
    __slots__ = ['start_time']

    def start(self, *args, **kwargs):
        self.start_time = _monotonic()

    def stop(self, *args, **kwargs):
        delta = _monotonic() - self.start_time
        if "TerminalInteractiveShell" in get_ipython().__class__.__name__:
            print(f'\033[33;1;2m\truntime: {_format_time(delta)}\033[0m')
        if delta > 10:
            _notify("ipython", f"finished in {_format_time(delta)}")


_ipython_autotimer = _IpythonAutoTimer()
get_ipython().events.register('pre_run_cell',  _ipython_autotimer.start)
get_ipython().events.register('post_run_cell', _ipython_autotimer.stop)
