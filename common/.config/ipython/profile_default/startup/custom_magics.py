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
