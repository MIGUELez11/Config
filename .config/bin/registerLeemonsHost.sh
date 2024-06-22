echo "
Host $1
\tUser ubuntu
\tHostname $2
\tPort 22
\tIdentityFile ~/.ssh/leemons.pem
" >> ~/.ssh/config

echo "Added $1 to ~/.ssh/config"