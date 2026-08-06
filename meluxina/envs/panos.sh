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
  'bash' \
  'bat' \
  'bison' \
  'btop' \
  'bubblewrap' \
  'cdo' \
  'cmake' \
  'codex' \
  'compilers' \
  'conda-pack' \
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
  'ipython' \
  'jq' \
  'libabseil' \
  'libgdal-hdf5' \
  'libglu' \
  'libhwloc' \
  'libnetcdf' \
  'llvm-openmp' \
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
  'poethepoet' \
  'poetry' \
  'pynvim' \
  'python=3.13.*' \
  'ripgrep' \
  'rsync' \
  'ruff' \
  'rust' \
  'setuptools' \
  'shellcheck' \
  'squashfs-tools' \
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
