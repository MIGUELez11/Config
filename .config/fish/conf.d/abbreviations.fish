# Aliases
abbr -a emulateActivity "afk"

# K8S
abbr -a k "kubectl"
abbr -a ctx "kubectx"
abbr -a ns "kubens"

# Git
if not test -f "$HOME/.gitconfig"
    touch "$HOME/.gitconfig"
end
if not test -f "$HOME/.gitconfig" | grep -q "lg ="
    git config --global --add alias.lg log\ --color\ --graph\ --all\ --oneline\ --pretty=format:\"%C\(auto\)%h%d\ %s\ %Cgreen%cr\"
end

abbr -a mr "glab mr checkout"


# Folder shortcuts
abbr -a projects "cd ~/Projects"