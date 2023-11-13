# .bash_profile
# https://unix.stackexchange.com/questions/94490/bash-doesnt-read-bashrc-unless-manually-started
#
# If .profile exists, source that one, too
if [[ -f ~/.profile ]]; then
  . ~/.profile
fi

# If the shell is interactive and .bashrc exists, get the aliases and functions
source ~/.bashrc
