#!/usr/bin/env bash

set -xeuo pipefail

micromamba install \
  --yes \
  --channel conda-forge \
  --name panos \
  bash \
  bat \
  btop \
  cdo \
  compilers \
  direnv \
  eccodes \
  fd-find \
  ffmpeg \
  fzf \
  gdal \
  git \
  git-delta \
  imagemagick \
  libabseil \
  libglu \
  libhwloc \
  moreutils \
  ncdu \
  nco \
  nodejs \
  'nvim<0.11' \
  ocl-icd-system \
  pipx \
  pynvim \
  'python>3.11' \
  'python<3.13' \
  ripgrep \
  rsync \
  rust \
  stow \
  tar \
  the_silver_searcher \
  tig \
  tree \
  vim \
  vmtouch \
  xorg-libxcursor  \
  xorg-libxft  \
  xorg-libxinerama  \
  yazi \
  zstd \
;
