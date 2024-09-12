## Enable starship, the cross-shell-prompt
eval "$(starship init zsh)"

## Enable Atuin for history management and sync
eval "$(atuin init zsh)"

## Add the local completions directory to the fpath
fpath=($HOME/.config/zsh/completions/ $fpath)

##
# Source fzf completions and keybindings
# See dpkg -L fzf for the location of the completions
# We copied these to be able to change them
source $HOME/.config/zsh/fzf/key-bindings.zsh
source $HOME/.config/zsh/fzf/completion.zsh

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/ber/.zshrc'

autoload -Uz compinit
compinit
unsetopt beep
bindkey -v

## Enable bash completion scripts
autoload -Uz bashcompinit
bashcompinit
# Load everything in ~.local/share/bash-completion/completions
for f in ~/.local/share/bash-completion/completions/*; do
  source $f
done

## RE-implement CTRL-P as up in vim insert mode (our default, see above)
# An alternative would be normal up-history, but we bind it to atuin.
# The alternative is:
# bindkey -M viins '^p' up-history
bindkey -M viins '^p' _atuin_search_widget

## Rbenv, the ruby version manager, switcher and installer
eval "$($HOME/.rbenv/bin/rbenv init - zsh)"

## Aliases. Can be shared with bash
source $HOME/.config/zsh/aliases

## CDPATH, for quick CD-ing into anything under documents
setopt auto_cd
cdpath=($HOME/Documents)

## PATH settings
### Add .local/bin
path+=$HOME/.local/bin

### Add golang
path+=/usr/local/go/bin
path+=/home/ber/go/bin

### Add deno 
path+=$HOME/.deno/bin

## App and tool configuration

### FZF
# Setting fd as the default source for fzf
# fd is an alias for fdfind, we use the canonical, non-aliased for portability
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix'
export FZF_DEFAULT_OPTS='--preview "batcat --color=always --decorations=never {}"'

### Bartib
export BARTIB_FILE="$HOME/.local/share/bartib/activities.bartib"

### Pipenv
PIPENV_QUIET=1 #shut up pipenv from printing it's messages to stderr which are not errors

## NVM, the node version manager.
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

. "$HOME/.atuin/bin/env"

## Enable zoxide, the directory jumping tool
# Must be somewhere at the end, after compinit and PATH and such
eval "$(zoxide init zsh --cmd=cd)"

## Set the title of the terminal
# Use the current directory as the title of the terminal
# But replace the home directory with ~
function set-title() {
  echo -ne "\033]0;${1//${HOME}/~}\007"
}

precmd() {
  set-title $PWD
}
