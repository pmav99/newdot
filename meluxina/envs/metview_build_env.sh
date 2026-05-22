#!/usr/bin/env bash

set -xeuo pipefail

source init_conda

name='metview_build_env'

if mamba env list | grep -q "${name}"; then
  echo "${name} already exists";
else
  conda create -y -n "${name}";
fi

micromamba install \
  --yes \
  --channel conda-forge \
  --name "${name}" \
  --verbose \
  'bash' \
  'bison' \
  'cairo' \
  'cmake' \
  'compilers' \
  'gdbm' \
  'git' \
  'hdf5' \
  'imagemagick' \
  'libglu' \
  'libhwloc' \
  'libnetcdf' \
  'llvm-openmp' \
  'netcdf-cxx4' \
  'pango' \
  'proj' \
  'python=3.13.*' \
  'qt' \
  'tar' \
  'xorg-libxcursor ' \
  'xorg-libxft ' \
  'xorg-libxinerama ' \
  'zstd' \
;
