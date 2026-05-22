#!/usr/bin/env bash

set -euo pipefail

name='panos'

if micromamba env list | grep -q "${name}"; then
  echo "${name} already exists";
else
  micromamba create -y -n "${name}";
fi

micromamba install \
  --yes \
  --channel conda-forge \
  --name panos \
  'basedpyright' \
  'ipython'
  'bash' \
  'bat' \
  'bison' \
  'btop' \
  'cdo' \
  'cmake' \
  'compilers' \
  'direnv' \
  'eccodes' \
  'fd-find' \
  'ffmpeg' \
  'fzf' \
  'gdal' \
  'gh' \
  'git' \
  'git-delta' \
  'imagemagick' \
  'inspectds' \
  'libabseil' \
  'llvm-openmp' \
  'libnetcdf' \
  'libgdal-hdf5' \
  'libglu' \
  'libhwloc' \
  'metis' \
  'moreutils' \
  'mosh' \
  'ncdu' \
  'nco' \
  'nodejs' \
  'nvim=0.11.*' \
  'ocl-icd-system' \
  'parallel' \
  'pipx' \
  'poetry' \
  'pynvim' \
  'python=3.13.*' \
  'ripgrep' \
  'rsync' \
  'ruff' \
  'rust' \
  'shellcheck' \
  'stow' \
  'tar' \
  'the_silver_searcher' \
  'tig' \
  'tree' \
  'uv' \
  'vim' \
  'viu' \
  'vmtouch' \
  'xorg-libxcursor ' \
  'xorg-libxft ' \
  'xorg-libxinerama ' \
  'yazi' \
  'zstd' \
;
