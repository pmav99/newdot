# Setup Traceback for dark themes
# https://github.com/ipython/ipython/pull/14138
# https://github.com/ipython/ipython/issues/14464
# https://stylishthemes.github.io/Syntax-Themes/pygments/
from IPython.core.ultratb import VerboseTB

VerboseTB.tb_highlight = "bg:#500060"
VerboseTB.tb_highlight_style = "monokai"
# VerboseTB.tb_highlight_style = "gruvbox-light"

c.TerminalInteractiveShell.editing_mode = 'vi'
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
c.InteractiveShell.ast_node_interactivity = "all"
