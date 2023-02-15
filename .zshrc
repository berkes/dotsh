## Enable starship, the cross-shell-prompt
eval "$(starship init zsh)"

## Enable Atuin for history management and sync
eval "$(atuin init zsh)"

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/ber/.zshrc'

autoload -Uz compinit
compinit
unsetopt beep
bindkey -v

## Rbenv, the ruby version manager, switcher and installer
eval "$($HOME/.rbenv/bin/rbenv init - zsh)"

## Aliases. Can be shared with bash
source $HOME/.config/zsh/aliases

## CDPATH, for quick CD-ing into anything under documents
setopt auto_cd
cdpath=($HOME/Documenten)

## PATH settings
### Add .local/bin
path+=$HOME/.local/bin

### Add golang
path+=/usr/local/go/bin
