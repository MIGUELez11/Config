#Enable colors and change prompt:
autoload -U colors && colors
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
#PS1="%B%{$fg[red]%}[%{$fg[cyan]%}%n%{$fg[magenta]%}@%{$fg[yellow]%}%m%{$fg[red]%}]%{$fg[magenta]%} %~%{$fg[blue]%} $%{$reset_color%}%b "
PS1="%B%{$fg[red]%}[%{$fg[cyan]%}%n%{$fg[magenta]%}@%{$fg[yellow]%}%m%{$fg[red]%}]%{$fg[blue]%} $%{$reset_color%}%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
source "$HOME/.config/zsh/shortcutrc"
source "$HOME/.config/zsh/aliasrc"

# Load zsh-syntax-highlighting; should be last.
source "$HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
