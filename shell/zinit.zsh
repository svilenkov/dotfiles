z_lucid() {
  zinit ice lucid ver'master' "$@"
}

zi0a() {
  z_lucid wait'0a' "$@"
}

zi0b() {
  z_lucid wait'0b' "$@"
}

zi0c() {
  z_lucid wait'0c' "$@"
}

function source_aliases() {
  source ~/.shell/aliases
}

function source_nvm_completion() {
  source $NVM_DIR/bash_completion
}

function source_lima_completion() {
	source <(limactl completion zsh)
}

function source_gcloud_completion() {
	source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
}

#zi ice pick"async.zsh" src"pure.zsh"
#zi light sindresorhus/pure

zinit ice wait'0a' lucid
zinit light wfxr/forgit

zinit ice wait'0b' atinit="source_aliases" lucid
zinit snippet $HOME/.shell/aliases

# sharkdp/bat
zinit ice wait lucid as'command' from'gh-r' mv'bat* -> bat' pick'bat/bat'
zinit light sharkdp/bat

# fd
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# interactive history
zstyle :plugin:history-search-multi-word reset-prompt-protect 1

#zinit load zdharma-continuum/history-search-multi-word
zinit load z-shell/H-S-MW
zinit light zsh-users/zsh-syntax-highlighting


# autolaod .nvmrc when cd into a dir that contains it
export NVM_AUTO_USE=true
export NVM_SYMLINK_CURRENT="true" # nvm use should make a symlink
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION="true"

zinit ice wait'0a' lucid
zinit light lukechilds/zsh-nvm

zinit ice wait'0b' atinit="source_nvm_completion" lucid
zinit snippet $HOME/.shell/aliases

zinit ice wait'0c' atinit="source_gcloud_completion" lucid
zinit snippet $HOME/.shell/aliases

zinit ice wait'0d' atinit="source_lima_completion" lucid
zinit snippet $HOME/.shell/aliases

zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
zinit light b4b4r07/httpstat

zinit ice wait'0d' lucid
zinit snippet ~/.shell/gpg_ready.zsh
