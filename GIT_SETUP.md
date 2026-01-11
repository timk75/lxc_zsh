# Git Repository Setup

This repository has been pushed to GitHub at: **git@github.com:timk75/lxc_zsh.git**

## Repository Status

The repository is already set up and pushed to GitHub. You can view it at:
https://github.com/timk75/lxc_zsh

## Quick One-Liner for LXC Containers

Since this is a **private** repository, you have two options for using the one-liner:

### Option 1: Make the repository public (easier)
If you make the repository public, you can use:
```bash
curl -fsSL https://raw.githubusercontent.com/timk75/lxc_zsh/main/lxc-zsh-setup.sh | bash
```

### Option 2: Use with authentication (private repo)
For private repositories, use a personal access token:
```bash
curl -fsSL -H "Authorization: token YOUR_GITHUB_TOKEN" https://raw.githubusercontent.com/timk75/lxc_zsh/main/lxc-zsh-setup.sh | bash
```

To create a token: https://github.com/settings/tokens

## Working with Secrets

The `.gitignore` file is configured to exclude:
- `secrets.yml` (your encrypted credentials)
- `inventory.ini` (your actual server IPs)
- `.vault_pass` (your vault password file)

This means your actual credentials and server information will **never** be committed to the repository.

## Making Changes

```bash
# Make your changes
git add .
git commit -m "Description of changes"
git push
```

## Cloning on Another Machine

```bash
git clone git@github.com:YOUR_USERNAME/lxc-zsh-setup.git
cd lxc-zsh-setup

# Set up your secrets
cp secrets.yml.example secrets.yml
nano secrets.yml
ansible-vault encrypt secrets.yml

# Set up your inventory
cp inventory.ini.example inventory.ini
nano inventory.ini
```
