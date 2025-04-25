function gpg_status() {
  SOCKET=$(gpgconf --list-dirs agent-socket)
  if lsof "$SOCKET" >/dev/null 2>&1; then
    echo "💠 GPG Agent Running (socket: $SOCKET)"
  else
    echo "⚡ GPG Agent NOT Running (socket missing: $SOCKET)"
  fi
}

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

