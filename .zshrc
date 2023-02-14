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

## Aliases. Can be shared with bash
source $HOME/.config/zsh/aliases
