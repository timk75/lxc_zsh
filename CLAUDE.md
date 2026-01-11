# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository automates ZSH shell setup for Proxmox LXC containers. It deploys a consistent ZSH environment with the Tokyo Night Storm theme, modern CLI tools (zoxide, fzf, eza), and Zinit plugin management.

**Target environment:** Debian/Ubuntu-based LXC containers
**GitHub repository:** git@github.com:timk75/lxc_zsh.git (private)

## Key Components

### Core Files

- **lxc-zsh-setup.sh** - Main installation script that runs on LXC containers. Installs ZSH, Zinit, oh-my-posh, and CLI tools, then generates a `.zshrc` configuration.
- **tokyo-night-storm.omp.json** - Custom oh-my-posh theme with Tokyo Night Storm colors hard-coded (so theme works without terminal color scheme changes).
- **deploy.sh** - Wrapper script to deploy from Mac to a single LXC container via SCP+SSH.

### Ansible Deployment (for multiple containers)

- **ansible-playbook.yml** - Copies and executes lxc-zsh-setup.sh on containers defined in inventory
- **inventory.ini.example** - Template for container IPs/hostnames
- **secrets.yml.example** - Template for credentials (encrypted with ansible-vault)
- **ansible.cfg** - Ansible configuration (references vault password file option)
- **host_vars/** - Directory for per-host credential overrides

### Secrets Management

All actual credentials are **gitignored** (`.gitignore` excludes `secrets.yml`, `inventory.ini`, `.vault_pass`). Only example files are committed.

## Common Commands

### Deploy to single container
```bash
./deploy.sh <container-ip>
```

### Deploy to multiple containers with Ansible
```bash
# First time setup
cp inventory.ini.example inventory.ini
cp secrets.yml.example secrets.yml
# Edit inventory.ini and secrets.yml, then:
ansible-vault encrypt secrets.yml

# Deploy
ansible-playbook -i inventory.ini --ask-vault-pass ansible-playbook.yml
```

### Manage Ansible vault
```bash
ansible-vault view secrets.yml      # View encrypted file
ansible-vault edit secrets.yml      # Edit encrypted file
ansible-vault rekey secrets.yml     # Change vault password
```

### Direct deployment from GitHub (on LXC container)
```bash
curl -fsSL https://raw.githubusercontent.com/timk75/lxc_zsh/main/lxc-zsh-setup.sh | bash
```

## Architecture Notes

### ZSH Configuration Strategy

The repository maintains **two separate .zshrc configurations**:

1. **Mac version** (user's local `~/.zshrc`) - Includes Homebrew, 1Password SSH agent, Bun, Go, Fabric-AI
2. **LXC version** (embedded in `lxc-zsh-setup.sh` as heredoc) - Stripped-down for Linux containers

When modifying ZSH config, update **both** if the change applies to both environments.

### Theme Color Philosophy

The Tokyo Night Storm theme (`tokyo-night-storm.omp.json`) has colors **hard-coded in the theme file itself**, not relying on terminal color schemes. This ensures consistent appearance across different terminal emulators.

Color palette:
- Blue `#7aa2f7` - Paths
- Magenta `#bb9af7` - Git branches
- Green `#9ece6a` - Success states
- Red `#f7768e` - Errors
- Cyan `#7dcfff` - Language versions
- Yellow `#e0af68` - Execution time

### Installation Script Structure

`lxc-zsh-setup.sh` follows this sequence:
1. OS detection (fails if not Debian/Ubuntu)
2. Package installation via apt-get (ZSH, curl, git, neovim, etc.)
3. Manual installation of tools not in apt (eza, fzf, zoxide, thefuck, oh-my-posh)
4. Zinit installation to `~/.local/share/zinit/`
5. Generate `.zshrc` via heredoc
6. Download `tokyo-night-storm.omp.json` from GitHub raw URL
7. Change default shell to ZSH

### Ansible Vault Integration

The Ansible playbook loads `secrets.yml` which can contain:
- Global credentials (`ansible_user`, `ansible_password`)
- Per-host credential overrides in `host_vars/<hostname>.yml`

The playbook references `secrets.yml` in `vars_files`, so it **must exist** before running (even if using host_vars exclusively).

## Modification Guidelines

### Updating the ZSH Configuration

If updating shell config:
1. Update local Mac `.zshrc` if needed
2. Update the heredoc in `lxc-zsh-setup.sh` (lines 85-137)
3. Consider differences between Mac (Homebrew paths) and Linux environments

### Changing the Theme

1. Modify `tokyo-night-storm.omp.json` locally
2. Commit and push to GitHub
3. The setup script downloads from: `https://raw.githubusercontent.com/timk75/lxc_zsh/main/tokyo-night-storm.omp.json`

### Adding New Tools

Add installation steps in `lxc-zsh-setup.sh` following the pattern:
1. Echo info message
2. Install/download tool
3. If it affects `.zshrc`, update the heredoc section

### Testing Changes

Test the setup script in a disposable LXC container before deploying broadly:
```bash
# On a test container
curl -fsSL https://raw.githubusercontent.com/timk75/lxc_zsh/main/lxc-zsh-setup.sh | bash
```

## Repository Conventions

- Private repository - requires authentication for raw file access
- All sensitive files (.vault_pass, secrets.yml, inventory.ini) are gitignored
- Example files (.example suffix) are committed as templates
- The main branch is `main`
- Co-authored commits include: `Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>`
