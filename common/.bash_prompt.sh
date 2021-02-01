#!/usr/bin/env bash
# WARNING: Sourcing of this file must happen **before** using eval on the direnv hook.
#

# we use __git_ps1 so we must source git-prompt.sh which comes in a different place
# in each distro.

# Archlinux
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh;
# debian & Ubuntu
elif [ -f /usr/lib/git-core/git-sh-prompt ]; then
    source /usr/lib/git-core/git-sh-prompt;
# centos
elif [  -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
else
    echo "couldn't find git-prompt.sh"
fi

#force_color_prompt=yes

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

function set_user() {
  if [ "$LOGNAME" = root ] || [ "`id -u`" -eq 0 ] ; then
    PROMPT_USER="${RED}\u${COLOR_NONE}"
  else
    PROMPT_USER="${WHITE}\u${COLOR_NONE}"
  fi
}

function set_virtualenv () {
  if test -z "${VIRTUAL_ENV}" ; then
    PYTHON_VIRTUALENV=""
  else
    PYTHON_VIRTUALENV="${LIGHT_GREEN}($(basename ${VIRTUAL_ENV}))${COLOR_NONE} "
  fi
}

function set_conda() {
  if test -z "${CONDA_DEFAULT_ENV}" ; then
    CONDA_ENV=""
  else
    CONDA_ENV="${LIGHT_RED}[${CONDA_DEFAULT_ENV}]${COLOR_NONE} "
  fi
}

function set_exit_status() {
  if [[ $? == 0 ]]; then
    EXIT_STATUS="${GREEN}$ ${COLOR_NONE}"
  else
    EXIT_STATUS="${RED}$ ${COLOR_NONE}"
  fi
}

# Set the full bash prompt
function set_bash_prompt () {
    # Set the PYTHON_VIRTUALENV variable.
    set_user
    set_exit_status
    set_virtualenv
    set_conda
    PS1="${CONDA_ENV}${PYTHON_VIRTUALENV}${debian_chroot:+($debian_chroot)}\D{%T} ${PROMPT_USER}${YELLOW}@${PURPLE}\h\[\033[00m\]:${BLUE}\w${YELLOW}$(__git_ps1)${EXIT_STATUS}"
}

# Execute this function before displaying prompt
PROMPT_COMMAND=set_bash_prompt

