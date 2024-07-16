#!/bin/bash

function legacyInstall() {
    sh ./scripts/setupZsh.sh 1> /dev/null
    sh ./scripts/setupVim.sh 1> /dev/null

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
        zsh
        exit 0
}

function promptForNewInstaller() {
    question="Should we use the NEW setup? (it will install Node.js)"
    command="legacyInstall"

    read -p "$question (y/n) " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo ""
        $command
    fi
}

clear;

promptForNewInstaller

clear;

source ./scripts/setupHomebrewAndNvm.sh

npm install -C ./installer

clear
node ./installer/main.js
zsh