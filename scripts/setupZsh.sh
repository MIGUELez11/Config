#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

echo Script $SCRIPT_DIR/../.config/zsh

unset ZDOTDIR
unset VIMINIT
touch $HOME/.zshenv

if ! cat $HOME/.zshenv | grep -q "export ZDOTDIR='$HOME/.config/zsh'"; then
	echo "export ZDOTDIR='$HOME/.config/zsh'">> "$HOME/.zshenv";
fi

if [ ! -d "$HOME/.config/zsh" ]; then
	mkdir -p $HOME/.config/zsh
fi

cp -rf $SCRIPT_DIR/../.config/zsh/.* $HOME/.config/zsh
cp -rf $SCRIPT_DIR/../.config/zsh/* $HOME/.config/zsh

if [ -d "$HOME/.config/zsh/zsh-syntax-highlighting" ]; then
	rm -rf $HOME/.config/zsh/zsh-syntax-highlighting
fi
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/zsh-syntax-highlighting