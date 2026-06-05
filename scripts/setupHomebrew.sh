
if ! command -v brew >/dev/null 2>&1; then
  echo "1.- Installing Homebrew"

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed"
fi

# Load Homebrew for the current session (fish PATH is persisted in setupShell.js)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Bun is the JS runtime used to install deps and run the installer.
if ! command -v bun >/dev/null 2>&1; then
  echo "2.- Installing Bun"
  brew install bun
else
  echo "Bun already installed"
fi
