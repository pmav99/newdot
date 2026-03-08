import glob
import os
import pathlib
import sys
import shlex
import shutil
import subprocess
import typing
import typing as T
import typing as ty

#------------------------------------------------------------------------------#
#-------------------------------- MAGICS --------------------------------------#
#------------------------------------------------------------------------------#
from IPython.core.magic import register_line_magic as _register_line_magic
#from IPython.core.magic import register_cell_magic as _register_cell_magic
#from IPython.core.magic import register_line_cell_magic as _register_line_cell_magic


@_register_line_magic
def bat(line):
    "Call `bat`"
    return get_ipython().system(f"bat {line}")

@_register_line_magic
def la(line):
    "Call `ls -lah`"
    return get_ipython().run_line_magic("ls", f" -lah {line}")

@_register_line_magic
def tree(line):
    "Call `ls -lah`"
    return get_ipython().run_line_magic("tree", f"{line}")


del bat, la, tree
#------------------------------------------------------------------------------#
#-------------------------------- MAGICS --------------------------------------#
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
#----------------------------- AUTOTIMER --------------------------------------#
#------------------------------------------------------------------------------#
# When on ipython console register a timer that shows the execution time of cells on Ipython
# Similar to: https://pypi.org/project/jupyterlab-execute-time/ just for ipython
#
# https://stackoverflow.com/questions/15411967/how-can-i-check-if-code-is-executed-in-the-ipython-notebook
# https://github.com/cpcloud/ipython-autotime/blob/5aacf36b4de1c4ba5fa46e077b627817b65ff53a/autotime/__init__.py
#
from time import monotonic as _monotonic

from IPython.core.magics.execution import _format_time


def _notify(title, msg):
    if shutil.which('ntfy'):
        subprocess.run(shlex.split(f"ntfy send '{title}-{msg}'"))
    elif shutil.which('ninfo'):
        subprocess.run(shlex.split(f"ninfo {title}: {msg}"))
    elif shutil.which('osascript'):
        subprocess.run(shlex.split(f"osascript -e 'display notification \"{msg}\" with title \"{title}\"'"))


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
# ---------------------------------------------------------------------------- #
# ---------------------------- AUTOTIMER ------------------------------------- #
# ---------------------------------------------------------------------------- #

# ---------------------------------------------------------------------------- #
# ------------------------------ VARIOUS ------------------------------------- #
# ---------------------------------------------------------------------------- #
def np_print(fmt: str = "13.5f", per_line: int = 5) -> None:
    import numpy as np
    N = int("".join(c for c in fmt.split(".")[0] if c.isdigit()))
    np.set_printoptions(
        linewidth=N * per_line + 2 * (per_line - 1) + 7 + 2,
        formatter={
            'float': f'{{:{fmt}}}'.format,
            'int': f'{{:{N}d}}'.format,
            'bool': f'{{:{N}}}'.format,
        },
    )
# ---------------------------------------------------------------------------- #
# ------------------------------ VARIOUS ------------------------------------- #
# ---------------------------------------------------------------------------- #
