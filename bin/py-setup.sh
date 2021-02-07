#!/bin/bash

set -e

url="https://github.com/momo-lab/xxenv-latest.git"
folder="$(pyenv root)/plugins/xxenv-latest"

if ! git clone "${url}" "${folder}" 2>/dev/null && [ -d "${folder}" ] ; then
    echo "Clone failed because the folder ${folder} exists"
fi

pyenv latest install

pyenv latest global

echo "Current Py: $(python --version)"
