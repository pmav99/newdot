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

if shopt -q login_shell; then
  echo END .bashrc
fi
