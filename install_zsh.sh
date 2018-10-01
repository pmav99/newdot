#!/bin/bash

# use strict mode: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -xeuo pipefail

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
git clone --recursive https://github.com/belak/prezto-contrib "${ZDOTDIR:-$HOME}/.zprezto/contrib"

