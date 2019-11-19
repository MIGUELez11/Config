#cp -f .zshenv $HOME/
unset ZDOTDIR
unset VIMINIT
touch $HOME/.zshenv
if ! cat $HOME/.zshenv | grep -q "export ZDOTDIR='$HOME/.config/zsh'"; then
	echo "export ZDOTDIR='$HOME/.config/zsh'">> "$HOME/.zshenv";
fi
if ! cat $HOME/.zshenv | grep -q "export VIMINIT='source \$HOME/.config/vim/.vimrc'"; then
	echo "export VIMINIT='source \$HOME/.config/vim/.vimrc'" >> "$HOME/.zshenv"
fi
cp -rf .config $HOME/
cp -rf .config/zsh/.zshrc $HOME/.config/zsh
cp -rf .config/vim/.vimrc $HOME/.config/vim
if [ -d "$HOME/.config/zsh/zsh-syntax-highlighting" ]; then
	rm -rf $HOME/.config/zsh/zsh-syntax-highlighting
fi
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/zsh-syntax-highlighting
cd $HOME
clear;
echo "MIGUELez11's Configuration has been loaded successfully."
echo ""
echo "Configuration files have been setted up in ~/.config"
zsh
