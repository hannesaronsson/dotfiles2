#!/usr/bin/env bash


set -e

# Editable lists of Homebrew packages, casks, and Aerospace options
BREW_PACKAGES=(
  stow
  neovim
  alacritty
  borders
  pyenv
  colima
  docker
  fzf
  htop
  tree
  poetry
)
BREW_CASKS=(
  font-fira-code-nerd-font
  visual-studio-code
  miniconda
)
AEROSPACE_OPTIONS=(
  --HEAD
  aerospace
)

# Check OS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "This install script is intended for macOS only."
  exit 1
fi

# Ensure Xcode Command Line Tools are installed
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
fi

# Disable press-and-hold for key repeat
echo "Disabling press-and-hold for key repeat..."
defaults write -g ApplePressAndHoldEnabled -bool false

# Install custom US no-dead-key keyboard layout if present
LAYOUT_SRC="keyboard-layouts/us_no_dead_key.keylayout"
if [ -f "$LAYOUT_SRC" ]; then
  echo "Installing custom keyboard layout..."
  sudo cp "$LAYOUT_SRC" "/Library/Keyboard Layouts/"
fi

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew and upgrade existing formulae
echo "Updating Homebrew..."
brew update
brew upgrade
brew analytics off

# Ensure required Homebrew packages
echo "Installing Homebrew packages: ${BREW_PACKAGES[*]}"
brew install "${BREW_PACKAGES[@]}"

# Configure Poetry to create virtual environments inside each project
echo "Configuring Poetry virtualenvs location..."
poetry config virtualenvs.in-project true

# Install FiraCode Nerd Font via Homebrew cask
brew tap homebrew/cask-fonts
echo "Installing Homebrew casks: ${BREW_CASKS[*]}"
brew install --cask "${BREW_CASKS[@]}"

# Start Colima for Docker compatibility
echo "Starting Colima service..."
brew services start colima
colima start

# Install oh-my-zsh if missing
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install aerospace (assuming from GitHub if not via Homebrew)
if ! command -v aerospace >/dev/null 2>&1; then
  echo "Installing aerospace..."
  brew install "${AEROSPACE_OPTIONS[@]}"
fi

# Stow dotfiles
echo "Stowing dotfiles..."
stow -t "${HOME}" nvim zsh alacritty aerospace

echo "Setup complete!"