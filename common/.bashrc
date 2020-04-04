# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Save 5,000 lines of history in memory
HISTSIZE=10000
# Save 2,000,000 lines of history to disk (will have to grep ~/.bash_history for full listing)
HISTFILESIZE=2000000
# Append to history instead of overwrite
shopt -s histappend
# Ignore redundant and don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# Ignore more
HISTIGNORE='ls:ll:ls -alh:pwd:clear:history'
# Set time format
HISTTIMEFORMAT='%F %T '
# Multiple commands on one line show up as a single line
shopt -s cmdhist
# Append new history lines, clear the history list, re-read the history list, print prompt.
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

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

# Use vim keybindings
set -o vi

export EDITOR=vim
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export PATH="${HOME}"/.local/my_bin:"${HOME}"/.local/bin:${PATH}

# XDG BASE directories
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=/tmp/$USER    # this directory is created in .zprofile
mkdir -p $XDG_DATA_HOME $XDG_RUNTIME_DIR $XDG_CACHE_HOME $XDG_CONFIG_HOME
chmod 700 "${XDG_RUNTIME_DIR}"

# Ipython and Jupyter
# Both projects have decided not to follow XDG.
# To circumvent this we need to add some ENV variables
# https://ipython.readthedocs.io/en/7.2.0/development/config.html#configuration-file-location
# https://github.com/jupyter/notebook/issues/1355#
export IPYTHONDIR=${XDG_CONFIG_HOME:-$HOME/.config}/ipython
export JUPYTER_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/jupyter
# JUPYTERLAB_DIR defines where jupyter extensions are being installed.
export JUPYTERLAB_DIR=${JUPYTER_CONFIG_DIR}/lab/
alias v='vim'

alias gco='git checkout'
alias gs='git stash'
alias gsa='git stash apply'
alias gsx='git stash drop'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls).
#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default on 'ls':
alias ls='ls -h --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.

# The ubiquitous 'll': directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

#-------------------------------------------------------------
# Tailoring 'less'
#-------------------------------------------------------------

alias more='less'
export PAGER=less
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
                # Use this if lesspipe.sh exists.
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Make some of the file manipulation programs verbose
alias mv="mv -vi"
alias rm="rm -vi"
alias cp="cp -vi"

alias grep='grep --color=auto'
alias grepp='grep -P --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ping1='ping -c3 1.1.1.1'
alias ping8='ping -c3 8.8.8.8'
alias pingg='ping -c3 www.google.com'

alias gtar='tar pcvzf'
alias btar='tar pcvjf'
alias untar='tar xvf'
alias ungtar='tar xvzf'
alias unbtar='tar xvjf'

# Journalctl aliases
alias jctl=journalctl
alias jspy='jctl -f'

# Systemctl aliases
alias reload='sudo systemctl reload'
alias restart='sudo systemctl restart'
alias start='sudo systemctl start'
alias sctl='sudo systemctl'
alias usctl='systemctl --user'
alias status='sudo systemctl -l status'
alias stop='sudo systemctl stop'

# docker
alias dc='docker'
alias dcc='docker container'
alias dci='docker image'
alias dcn='docker network'
alias dcv='docker volume'
alias dcmp='docker-compose'

# if gvim does not exist (i.e. in a server) use vim
if ! [ -x "$(command -v gvim)" ]; then
  alias gvim='vim'
  alias gvimdiff='vimdiff'
fi

# direnv
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi

# NTFY notifications
if [ -x "$(command -v ntfy)" ]; then
    eval "$(ntfy shell-integration)"
fi

# fzf
if [ $commands[fzf] ]; then
  export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
  alias vv='gvim $(fzf)'
  export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
  if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
  elif [ -f /usr/share/bash-completion/completions/fzf ]; then
    source /usr/share/bash-completion/completions/fzf
    source /usr/share/doc/fzf/examples/key-bindings.bash
  elif [ -f "${HOME}"/.fzf/shell/key-bindings.bash ]; then
    source "${HOME}"/.fzf/shell/key-bindings.bash
    source "${HOME}"/.fzf/shell/completion.bash
  else
    echo "couldn't find fzf files"
  fi
fi

function x()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Fix prompt for bash
# https://github.com/direnv/direnv/wiki/Python#bash
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}
export -f show_virtual_env
PS1='$(show_virtual_env)'$PS1
