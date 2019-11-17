cp -f .zshenv $HOME/
cp -rf .config $HOME/
cp -rf .config/zsh/.zshrc $HOME/
if [ -d "$HOME/.config/zsh/zsh-syntax-highlighting" ]; then
	rm -rf $HOME/.config/zsh/zsh-syntax-highlighting
fi
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/zsh-syntax-highlighting
clear;
echo "MIGUELez11's Configuration has been loaded successfully."
echo ""
echo "Configuration files have been setted up in ~/.config"
zsh
