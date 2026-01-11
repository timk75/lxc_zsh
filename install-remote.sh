#!/bin/bash
# One-liner installer that can be called via curl from a raw GitHub URL
# Usage: curl -fsSL https://raw.githubusercontent.com/timk75/lxc_zsh/main/install-remote.sh | bash

set -e

REPO_URL="https://raw.githubusercontent.com/timk75/lxc_zsh/main"
SCRIPT_NAME="lxc-zsh-setup.sh"

echo "Downloading ZSH setup script..."
curl -fsSL "${REPO_URL}/${SCRIPT_NAME}" -o "/tmp/${SCRIPT_NAME}"

echo "Making script executable..."
chmod +x "/tmp/${SCRIPT_NAME}"

echo "Running setup..."
"/tmp/${SCRIPT_NAME}"

echo "Cleaning up..."
rm "/tmp/${SCRIPT_NAME}"

echo ""
echo "Setup complete! Run 'exec zsh' to start using ZSH."
