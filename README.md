# LXC ZSH Setup Script

This script automates the setup of ZSH with your preferred configuration on Proxmox LXC containers.

## Deployment Methods

### Method 1: Quick Deploy Script (Recommended)

The easiest way to deploy to a single container:

```bash
./deploy.sh 192.168.1.100
# or with custom user
./deploy.sh mycontainer.local root
```

### Method 2: GitHub One-Liner (Best for Quick Setup)

If you host this on GitHub, you can run it directly on any LXC container:

```bash
# On the LXC container, run:
curl -fsSL https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/lxc-zsh-setup/lxc-zsh-setup.sh | bash
```

To set this up:
1. Create a GitHub repository
2. Push this folder to the repo
3. Update the URL in the command above
4. Run the one-liner on any container

### Method 3: Ansible Playbook (Best for Multiple Containers)

For deploying to many containers at once:

1. Copy `inventory.ini.example` to `inventory.ini` and add your container IPs:
   ```bash
   cp inventory.ini.example inventory.ini
   nano inventory.ini
   ```

2. Run the playbook:
   ```bash
   ansible-playbook -i inventory.ini ansible-playbook.yml
   ```

### Method 4: Manual Deployment

1. Copy the script to your LXC container:
   ```bash
   scp lxc-zsh-setup.sh root@your-lxc-ip:~/
   ```

2. SSH into your LXC container:
   ```bash
   ssh root@your-lxc-ip
   ```

3. Run the setup script:
   ```bash
   chmod +x lxc-zsh-setup.sh
   ./lxc-zsh-setup.sh
   ```

4. After completion, either log out and back in, or run:
   ```bash
   exec zsh
   ```

### Method 5: Proxmox Snippets (Advanced)

Store the script in Proxmox's snippet storage:

1. Copy to Proxmox host:
   ```bash
   scp lxc-zsh-setup.sh root@proxmox-host:/var/lib/vz/snippets/
   ```

2. Execute in any container from Proxmox:
   ```bash
   pct exec <CTID> -- bash /var/lib/vz/snippets/lxc-zsh-setup.sh
   ```

## What Gets Installed

- **ZSH** - The Z shell
- **Zinit** - Plugin manager for ZSH
- **ZSH Plugins**:
  - zsh-completions
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- **oh-my-posh** - Modern prompt theme engine
- **zoxide** - Smarter cd command
- **fzf** - Fuzzy finder
- **thefuck** - Command corrector
- **eza** - Modern replacement for ls
- **neovim** - Modern Vim

## Configuration Changes from Mac

The script creates a `.zshrc` adapted for Linux environments:

### Removed (Mac-specific)
- Homebrew paths and integrations
- iTerm2 shell integration
- 1Password SSH agent configuration
- Bun completions
- Go/GOPATH configuration
- Fabric-AI aliases and patterns

### Kept
- All ZSH history settings
- Zinit plugin manager with the same plugins
- oh-my-posh prompt (powerlevel10k_lean theme)
- zoxide, fzf, and thefuck integrations
- Basic aliases (vim→nvim, c→clear, ls→eza)

## Customization

After running the script, you can edit `~/.zshrc` to:
- Add back any removed features you need (Go, Bun, Fabric, etc.)
- Add custom aliases
- Change the oh-my-posh theme
- Add additional Zinit plugins

## Troubleshooting

- If you get permission errors, make sure you're running as root
- If eza installation fails, it will skip but other tools will still install
- The script is designed for Debian/Ubuntu-based LXC containers
- For other distributions, package installation commands may need adjustment

## Requirements

- Debian or Ubuntu-based LXC container
- Internet connection
- Root access
