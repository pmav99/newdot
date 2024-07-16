# When on ipython console register a timer that shows the execution time of cells on Ipython
# Similar to: https://pypi.org/project/jupyterlab-execute-time/ just for ipython
#
# https://stackoverflow.com/questions/15411967/how-can-i-check-if-code-is-executed-in-the-ipython-notebook
# https://github.com/cpcloud/ipython-autotime/blob/5aacf36b4de1c4ba5fa46e077b627817b65ff53a/autotime/__init__.py
#
if "TerminalInteractiveShell" in get_ipython().__class__.__name__:
    from time import monotonic as _monotonic
    from IPython.core.magics.execution import _format_time

    class _IpythonAutoTimer(object):
        __slots__ = ['start_time']

        def start(self, *args, **kwargs):
            self.start_time = _monotonic()

        def stop(self, *args, **kwargs):
            delta = _monotonic() - self.start_time
            print(f'\033[33;1;2m\truntime: {_format_time(delta)}\033[0m')

    _ipython_autotimer = _IpythonAutoTimer()
    get_ipython().events.register('pre_run_cell',  _ipython_autotimer.start)
    get_ipython().events.register('post_run_cell', _ipython_autotimer.stop)
