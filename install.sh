#!/usr/bin/env bash


set -e

# Editable lists of Homebrew packages, casks, and Aerospace options
BREW_PACKAGES=(
  stow
  neovim
  alacritty
  borders
)
BREW_CASKS=(
  font-fira-code-nerd-font
  visual-studio-code
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

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew and upgrade existing formulae
echo "Updating Homebrew..."
brew update
brew upgrade

# Ensure required Homebrew packages
echo "Installing Homebrew packages: ${BREW_PACKAGES[*]}"
brew install "${BREW_PACKAGES[@]}"

# Install FiraCode Nerd Font via Homebrew cask
brew tap homebrew/cask-fonts
echo "Installing Homebrew casks: ${BREW_CASKS[*]}"
brew install --cask "${BREW_CASKS[@]}"

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
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Stowing dotfiles from ${DOTFILES_DIR}..."
stow -d "${DOTFILES_DIR}" -t "${HOME}" nvim zsh alacritty aerospace

echo "Setup complete!"