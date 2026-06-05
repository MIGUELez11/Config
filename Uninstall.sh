rm -rf $HOME/.config/fish
rm -rf $HOME/.config/vim
rm -f $HOME/.config/starship.toml
fish -c "set -e VIMINIT" 2>/dev/null
cd $HOME
clear;
echo "MIGUELez11's Config has been uninstalled"
echo ""
