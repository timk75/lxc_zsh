#!/bin/bash
# Quick deployment script to run setup on remote LXC containers

if [ $# -eq 0 ]; then
    echo "Usage: ./deploy.sh <lxc-ip-or-hostname> [user]"
    echo "Example: ./deploy.sh 192.168.1.100"
    echo "Example: ./deploy.sh mycontainer.local root"
    exit 1
fi

LXC_HOST="$1"
LXC_USER="${2:-root}"

echo "Deploying ZSH setup to ${LXC_USER}@${LXC_HOST}..."

# Copy the setup script
scp lxc-zsh-setup.sh "${LXC_USER}@${LXC_HOST}:~/"

# Execute the script
ssh "${LXC_USER}@${LXC_HOST}" "chmod +x ~/lxc-zsh-setup.sh && ~/lxc-zsh-setup.sh"

echo ""
echo "Setup complete! SSH into your container and run 'exec zsh' to start using ZSH."
