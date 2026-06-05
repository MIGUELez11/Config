#!/bin/bash

clear;

source ./scripts/setupHomebrewAndNvm.sh

npm install -C ./installer

clear
node ./installer/main.js

echo "\033[1;32m"
echo "┌──────────────────────────────────────┐"
echo "│ MIGUELez11's Configuration has been  │"
echo "│ loaded successfully.                 │"
echo "│                                      │"
echo "│ Configuration files have been setted │"
echo "│ up in ~/.config                      │"
echo "└──────────────────────────────────────┘"
echo "\033[0m"

cd $HOME
exec fish
