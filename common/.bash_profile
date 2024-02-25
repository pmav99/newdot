# .bash_profile
# https://unix.stackexchange.com/questions/94490/bash-doesnt-read-bashrc-unless-manually-started
#
if shopt -q login_shell; then
  echo START .bash_profile
fi
# If .profile exists, source that one, too
if [[ -f ~/.profile ]]; then
  . ~/.profile
fi

# If the shell is interactive and .bashrc exists, get the aliases and functions
if [[ -f ~/.bashrc ]]; then
  . ~/.bashrc
fi

if shopt -q login_shell; then
  echo END .bash_profile
fi
