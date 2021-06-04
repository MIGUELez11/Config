#Enable colors and change prompt:
autoload -U colors && colors

#Enable right prompt
setopt prompt_subst

#Checks if we are on a git repo and displays branch
function parse_git_branch() {
	inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
	if [ "$inside_git_repo" ]; then
		ref="$(command git symbolic-ref --short HEAD 2> /dev/null)" || return
		echo "$(White)[$(Green)$ref$(White)]";
	else
		return
	fi
}

#Prompt variable definition
function Red()
{
	echo "%{$fg[red]%}"
}
function Cyan() {
	echo "%{$fg[cyan]%}"
}
function Magenta() {
	echo "%{$fg[magenta]%}"
}
function Yellow() {
	echo "%{$fg[yellow]%}"
}
function Blue() {
	echo "%{$fg[blue]%}"
}
function Green() {
	echo "%{$fg[green]%}"
}
function White() {
	echo "%{$fg[white]%}"
}

PromptReset="%{$reset_color%}%b"
PromptUserHost="%B$(Red)[$(Cyan)%n$(Magenta)@$(Yellow)%m$(Red)]"
PromptDirectory="$(Magenta)%c"
PromptS="$(Blue)$"

export PROMPT="$PromptUserHost $PromptDirectory $PromptS $PromptReset"
export RPROMPT='%B$(parse_git_branch)$PromptReset'

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

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
