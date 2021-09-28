#!/bin/bash

set -e

url="https://github.com/ctrlpvim/ctrlp.vim.git"
folder="~/.vim/bundle/ctrlp.vim"

if ! git clone "${url}" "${folder}" 2>/dev/null && [ -d "${folder}" ] ; then
    echo "Clone skipped because the folder ${folder} exists"
fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +'PlugInstall --sync' +qa
