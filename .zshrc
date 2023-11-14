## Enable starship, the cross-shell-prompt
eval "$(starship init zsh)"

## Enable Atuin for history management and sync
eval "$(atuin init zsh)"

## Add the local completions directory to the fpath
fpath=($HOME/.config/zsh/completions/ $fpath)

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/ber/.zshrc'

autoload -Uz compinit
compinit
unsetopt beep
bindkey -v

## RE-implement CTRL-P as up in vim insert mode (our default, see above)
# An alternative would be normal up-history, but we bind it to atuin.
# The alternative is:
# bindkey -M viins '^p' up-history
bindkey -M viins '^p' _atuin_search_widget

## Rbenv, the ruby version manager, switcher and installer
eval "$($HOME/.rbenv/bin/rbenv init - zsh)"

## NVM, the node version manager.
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

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

## App and tool configuration

### FZF
# Setting fd as the default source for fzf
# fd is an alias for fdfind, we use the canonical, non-aliased for portability
export FZF_DEFAULT_COMMAND='fdfind --type f --strip-cwd-prefix'
export FZF_DEFAULT_OPTS='--preview "batcat --color=always --decorations=never {}"'

### Bartib
export BARTIB_FILE="$HOME/.local/share/bartib/activities.bartib"

