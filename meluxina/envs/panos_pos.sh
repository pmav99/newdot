#!/usr/bin/env bash
#

set -Eeo pipefail

source init_conda

name='panos_pos'

if mamba env list | grep -q "${name}"; then
  echo "${name} already exists";
else
  conda create -y -n "${name}";
fi

mamba install \
  --yes \
  --name "${name}" \
  --strict-channel-priority \
  -f "${PREG}"/repos/pyPoseidon/locks/conda-ubuntu-latest-binary-p3.12.lock \
;
