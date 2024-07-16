
if ! command -v brew >/dev/null 2>&1; then
  echo "1.- Installing Homebrew"

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed"
fi

# Load Homebrew
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/MIGUELez11/.config/zsh/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v nvm >/dev/null 2>&1; then
  echo "2.- Installing nvm"
  brew install nvm
else
  echo "nvm already installed"
fi

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

if ! node -v | grep -q 20; then
  echo "3.- Installing Node.js"
  nvm install 20
nvm use 20