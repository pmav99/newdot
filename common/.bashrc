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

if shopt -q login_shell; then
  echo END .bashrc
fi
