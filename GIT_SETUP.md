# Git Repository Setup

This repository is now initialized and ready to be pushed to a private GitHub repository.

## Push to a New GitHub Private Repository

### Option 1: GitHub CLI (Recommended)

```bash
# Create a private repository on GitHub
gh repo create lxc-zsh-setup --private --source=. --remote=origin

# Push your code
git push -u origin main
```

### Option 2: Manual Setup

1. Create a new private repository on GitHub (https://github.com/new)
   - Name: `lxc-zsh-setup`
   - Visibility: **Private**
   - Don't initialize with README (we already have one)

2. Add the remote and push:
   ```bash
   git remote add origin git@github.com:YOUR_USERNAME/lxc-zsh-setup.git
   git push -u origin main
   ```

## After Pushing to GitHub

Update the GitHub one-liner in README.md to use your actual repository URL:

```bash
# Replace this line in README.md:
curl -fsSL https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/lxc-zsh-setup/lxc-zsh-setup.sh | bash

# With your actual URL:
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/lxc-zsh-setup/main/lxc-zsh-setup.sh | bash
```

**Note:** For private repositories, you'll need to authenticate or use a personal access token in the URL.

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
