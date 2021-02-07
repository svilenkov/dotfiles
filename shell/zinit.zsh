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

zinit ice wait'0a' lucid
zinit light wfxr/forgit

zinit ice wait'0b' atinit="source_aliases" lucid
zinit snippet $HOME/.shell/aliases
