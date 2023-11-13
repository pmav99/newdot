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
export PROMPT_COMMAND="history -a; history -n; history -c; history -r; ${PROMPT_COMMAND:-}"

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
source ~/.shell_common

# Use vim keybindings
set -o vi
export PATH="${HOME}"/.local/my_bin:"${HOME}"/.local/bin:${PATH}

# direnv
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi

# fzf
if [ -x "$(command -v fzf)" ]; then
  # The common configuration is in .shell_common
  # Here we have just the bash specific stuff
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
fi

if [[ -f "${HOME}"/.bashrc.custom ]]; then
  source "${HOME}"/.bashrc.custom
fi

if [[ -f "${HOME}"/.bashrc.bdap ]]; then
  source "${HOME}"/.bashrc.bdap
fi
