# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export TERM=xterm-256color

# Save 5,000 lines of history in memory
HISTSIZE=10000
# Save 2,000,000 lines of history to disk (will have to grep ~/.bash_history for full listing)
HISTFILESIZE=2000000
# Append to history instead of overwrite
shopt -s histappend
# Ignore redundant and don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth:erasedups
# Ignore more
HISTIGNORE='ls:ll:la:ls -alh:ls -lah:exit:pwd:clear:history'
# Set time format
HISTTIMEFORMAT='%F %T '
# Multiple commands on one line show up as a single line
shopt -s cmdhist
# Append new history lines, clear the history list, re-read the history list, print prompt.
export PROMPT_COMMAND="history -a; history -n; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Setup prompt
source "${HOME}"/.bash_prompt.sh

# Setup aliases
source ~/.shell_aliases

# Use vim keybindings
set -o vi
export EDITOR=vim
export SYSTEMD_EDITOR=vim
export PATH="${HOME}"/.local/my_bin:"${HOME}"/.local/bin:${PATH}

# XDG BASE directories
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=/var/run/user/$(id -u)
mkdir -p $XDG_CONFIG_HOME $XDG_CACHE_HOME  $XDG_DATA_HOME

export PYTHONSTARTUP=~/.pythonrc.py

# Ipython and Jupyter
# Both projects have decided not to follow XDG.
# To circumvent this we need to add some ENV variables
# https://ipython.readthedocs.io/en/7.2.0/development/config.html#configuration-file-location
# https://github.com/jupyter/notebook/issues/1355#
export IPYTHONDIR=${XDG_CONFIG_HOME:-$HOME/.config}/ipython
export JUPYTER_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/jupyter
# JUPYTERLAB_DIR defines where jupyter extensions are being installed.
export JUPYTERLAB_DIR=${JUPYTER_CONFIG_DIR}/lab/

# Go and R
export GOPATH=~/Prog/go
export GOBIN=~/Prog/go/bin
export GOARCH=amd64
export GOOS=linux
export R_LIBS="$HOME/.R"

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------
export PAGER=less
export LESSCHARSET='utf-8'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.
export LESS='-i -w -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# direnv
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi

# NTFY notifications
if [ -x "$(command -v ntfy)" ]; then
    eval "$(ntfy shell-integration)"
    export AUTO_NTFY_DONE_IGNORE="vim gvim screen tmux"
fi

# kubernetes
if [ -x "$(command -v kubectl)" ]; then
    source <(kubectl completion ${0});
fi

# fzf
if [ -x "$(command -v fzf)" ]; then
  # configure
  if [ -x "$(command -v bat)" ]; then
    export FZF_DEFAULT_OPTS="--height 40% --reverse --border --preview 'bat --color=always --line-range :100 {}'"
  else
    export FZF_DEFAULT_OPTS="--height 40% --reverse --border --preview 'head -n100 {}'"
  fi
  # Use fd if it is available and fallback to ag
  if [ $commands[fd] ]; then
    export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden --follow --exclude .git --exclude .tox'
    export FZF_ALT_C_COMMAND='fd --type d --color=never --hidden --follow --exclude .git --exclude .tox'
  elif [ $commands[ag] ]; then
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .tox -g ""'
  fi
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # key bindings
  if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
  elif [ -f /usr/share/bash-completion/completions/fzf ]; then
    source /usr/share/bash-completion/completions/fzf
    source /usr/share/doc/fzf/examples/key-bindings.bash
  elif [ -f /usr/share/doc/fzf/examples/completion.bash ]; then
    source /usr/share/doc/fzf/examples/completion.bash
    source /usr/share/doc/fzf/examples/key-bindings.bash
  elif [ -f "${HOME}"/.fzf/shell/key-bindings.bash ]; then
    source "${HOME}"/.fzf/shell/key-bindings.bash
    source "${HOME}"/.fzf/shell/completion.bash
  else
    echo "couldn't find fzf key-bindings"
  fi
  # aliases
  alias vv='gvim $(fzf)'
fi

export GPG_TTY=$(tty)
