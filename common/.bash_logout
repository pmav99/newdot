# .bash_logout
#
if shopt -q login_shell; then
  echo START .bash_logout
fi

echo "Goodbye!"

if shopt -q login_shell; then
  echo END .bash_logout
fi

