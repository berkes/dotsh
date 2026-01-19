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

# Load all functions in .config/zsh/functions/
for f in ~/.config/zsh/functions/*; do
  source $f
done

## RE-implement CTRL-P as up in vim insert mode (our default, see above)
# An alternative would be normal up-history, but we bind it to atuin.
# The alternative is:
# bindkey -M viins '^p' up-history
bindkey -M viins '^p' _atuin_search_widget

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

### Add jdt-ls the java language server
path+=$HOME/src/jdt-ls/bin

## App and tool configuration

### FZF
# Setting fd as the default source for fzf
# fd is an alias for fdfind, we use the canonical, non-aliased for portability
show_file_or_dir_preview="if [ -d {} ]; then exa --tree --color=always {} ; else bat --color=always --decorations=never {} ; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'exa --tree --color=always {}' | head -n 200'"

### Generative Art Projects
export SAVES_LOCATION="${HOME}/Dropbox/genArt/"

### Diodon, the clipboard manager
export ZEITGEIST_DATABASE_PATH=:memory:

autoload -U add-zsh-hook

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
