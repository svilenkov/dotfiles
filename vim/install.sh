#!/bin/bash

set -e
 #set -x  # to debu

url="https://github.com/ctrlpvim/ctrlp.vim.git"
folder="$HOME/.vim/bundle/ctrlp.vim"

if [ -d "${folder}" ] ; then
	cd "${folder}"
	git pull
	cd -
else
	git clone "${url}" "${folder}"
fi

curl -s -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +'PlugInstall --sync' +qa
nvim +'PlugInstall --sync' +qa

# Symlink coc-settings.json
ln -sf "$HOME/work/dotfiles/vim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"
echo "symlink $HOME/.config/nvim/coc-settings.json → $HOME/work/dotfiles/vim/coc-settings.json"

if command -v nvim >/dev/null 2>&1; then
  echo "📦 Installing coc.nvim extensions (Neovim only)..."

  extensions=(
    coc-clangd
    coc-snippets
    coc-solargraph
    coc-rust-analyzer
  )

  for ext in "${extensions[@]}"; do
    if ! grep -q "$ext" ~/.config/coc/extensions/package.json 2>/dev/null; then
      nvim --headless +":CocInstall -sync $ext" +qa
    else
      echo "✅ $ext already installed"
    fi
  done

  # TreeSitter
  echo "🌳 Installing all nvim-treesitter parsers (Neovim only)..."
  nvim --headless +'silent! TSUpdateSync' +qa || echo "⚠️ Tree-sitter update failed. Possibly due to Neovim version mismatch."
fi
