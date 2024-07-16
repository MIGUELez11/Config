#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

if ! cat $HOME/.zshenv | grep -q "export VIMINIT='source \$HOME/.config/vim/.vimrc'"; then
	echo "export VIMINIT='source \$HOME/.config/vim/.vimrc'" >> "$HOME/.zshenv"
fi

if [ ! -d "$HOME/.config/vim" ]; then
	mkdir -p $HOME/.config/vim
fi

cp -rf $SCRIPT_DIR/../.config/vim/* $HOME/.config/vim
cp -rf $SCRIPT_DIR/../.config/vim/.* $HOME/.config/vim