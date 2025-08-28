#!/usr/bin/env bash

set -xeuo pipefail

micromamba install \
  --yes \
  --channel conda-forge \
  --name panos \
  'basedpyright' \
  'bash' \
  'bat' \
  'btop' \
  'cdo' \
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
  'libabseil' \
  'libgdal-hdf5' \
  'libglu' \
  'libhwloc' \
  'metis' \
  'metview-batch' \
  'moreutils' \
  'mosh' \
  'ncdu' \
  'nco' \
  'nodejs' \
  'nvim=0.11.*' \
  'ocl-icd-system' \
  'pipx' \
  'pynvim' \
  'python=3.12.*' \
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
  'vim' \
  'vmtouch' \
  'xorg-libxcursor ' \
  'xorg-libxft ' \
  'xorg-libxinerama ' \
  'yazi' \
  'zstd' \
;
