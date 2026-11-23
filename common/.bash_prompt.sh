#!/usr/bin/env bash
# Source this file before installing the direnv hook.

_posh_dir="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh"
if command -v oh-my-posh >/dev/null 2>&1 && [[ -r "$_posh_dir/prompt.omp.json" && -r "$_posh_dir/host.sh" ]]; then
    source "$_posh_dir/host.sh"
    eval "$(oh-my-posh init bash --config "$_posh_dir/prompt.omp.json")"
else
    source "$HOME/.bash_prompt.legacy.sh"
fi
export -n PROMPT_COMMAND
unset _posh_dir
