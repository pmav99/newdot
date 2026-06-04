if shopt -q login_shell; then
  echo START .bashrc
fi

if [[ -f "${HOME}"/.bashrc.pre ]]; then
  source "${HOME}"/.bashrc.pre
fi

if [[ -f "${HOME}"/.bashrc.main ]]; then
  source "${HOME}"/.bashrc.main
fi

if [[ -f "${HOME}"/.bashrc.post ]]; then
  source "${HOME}"/.bashrc.post
fi

# Activate the default conda env after host-specific post config has set it.
if [[ $- == *i* ]] && [[ -n "${DEFAULT_CONDA_ENV:-}" ]] && command -v micromamba >/dev/null 2>&1; then
  micromamba activate "${DEFAULT_CONDA_ENV}"
fi

# direnv may come from the default conda env, so load it after activation.
if [[ $- == *i* ]] && command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# ts may come from the default conda env, so load it after activation.
if [ -x "$(command -v ts)" ]; then
  alias TSI='ts -i "%H:%M:%.S"'
  alias TSS='ts -s "%H:%M:%.S"'
  alias TS='ts -i "%H:%M:%.S" | ts -s "%H:%M:%.S"'
fi


force_path_front() {
  local dir=$1
  local rest=":${PATH}:"
  rest=${rest//:${dir}:/:}
  rest=${rest#:}
  rest=${rest%:}
  export PATH="${dir}${rest:+:${rest}}"
}

force_path_front "${HOME}/.local/my_bin"

if shopt -q login_shell; then
  echo END .bashrc
fi
