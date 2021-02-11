# History
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY      # Share history between all sessions.
setopt HIST_IGNORE_DUPS   # Don't record an entry that was just recorded again.
setopt HIST_FIND_NO_DUPS  # Do not display a line previously found.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g ZPLG_MOD_DEBUG=1
#zmodload zsh/zprof

zpt() { zplugin ice wait"${1}" lucid               "${@:2}"; } # Turbo
zpi() { zplugin ice lucid                            "${@}"; } # Regular Ice
zp()  { [ -z $2 ] && zplugin light "${@}" || zplugin "${@}"; } # zplugin

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# A.
setopt promptsubst

# B.
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv; unalias gr" \
        OMZP::git

PS1="READY >"

# C.
zinit wait'!' lucid for \
    OMZL::prompt_info_functions.zsh
    # OMZT::robbyrussell

zinit ice depth=1; zinit light romkatv/powerlevel10k

# D.
zinit wait lucid for \
  atinit"zicompinit; zicdreplay"  \
        zdharma/fast-syntax-highlighting \
      OMZP::colored-man-pages \
  as"completion" \
        OMZP::docker/_docker

# https://github.com/zdharma/zinit/issues/325
zinit snippet OMZ::lib/completion.zsh

bindkey -v

NEWLINE=$'\n'
PROMPT="${ret_status} %{$fg[cyan]%}%c%{$reset_color%} "

# User configuration
source ~/.shell/helpers

alias resrc="source ~/.zshrc"

export GOPATH="$HOME/go"

alias venc='vim -i NONE -x'
alias vopen='vim -i NONE'
alias vsee='vim -i NONE -M'

#export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"

export PATH="$PATH:$HOME/.rvm/bin:$GOPATH/bin"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/usr/local/sbin:$HOME/Scripts:$HOME/openocd/bin::$PATH"
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$(brew --prefix openssl)/bin:$PATH"

export DOCKER_HOST="ssh://root@192.168.64.17"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

###-tns-completion-start-###
if [ -f $HOME/.tnsrc ]; then
    source $HOME/.tnsrc
fi
###-tns-completion-end-###

eval "$(pyenv init - --no-rehash)"
eval "$(pyenv virtualenv-init - --no-rehash)"

transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

zinit snippet $HOME/.shell/goto.sh

source $HOME/.shell/zinit.zsh

# zprof

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
