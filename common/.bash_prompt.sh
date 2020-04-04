# we use __git_ps1
# This requires `bash-completion` to have been installed.
#
# WARNING: Sourcing of this file must happen **before** using eval on the direnv hook.
#

force_color_prompt=yes

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
     PURPLE="\[\033[1;35m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# Determine active Python virtualenv details.
function set_virtualenv () {
    if test -z "$VIRTUAL_ENV" ; then
        PYTHON_VIRTUALENV=""
    else
        PYTHON_VIRTUALENV="${LIGHT_GREEN}(`basename \"$VIRTUAL_ENV\"`)${COLOR_NONE} "
    fi
}


set_exit_status() {
    if [[ $? == 0 ]]; then
        EXIT_STATUS="${GREEN}$ ${COLOR_NONE}"
    else
        EXIT_STATUS="${RED}$ ${COLOR_NONE}"
    fi
}


# Set the full bash prompt
function set_bash_prompt () {
    # Set the PYTHON_VIRTUALENV variable.
    set_exit_status
    set_virtualenv
    PS1="${PYTHON_VIRTUALENV}${debian_chroot:+($debian_chroot)}${WHITE}\u${YELLOW}@${PURPLE}\h\[\033[00m\]:${BLUE}\w${YELLOW}$(__git_ps1)${EXIT_STATUS}"
}

# Execute this function before displaying prompt
PROMPT_COMMAND=set_bash_prompt

