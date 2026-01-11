#!/bin/bash
set -e

# Ensure HOME is set (required for some LXC environments)
export HOME=${HOME:-/root}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo_error "Cannot detect OS"
    exit 1
fi

echo_info "Detected OS: $OS"

# Update package list
echo_info "Updating package list..."
apt-get update

# Install ZSH
echo_info "Installing ZSH..."
apt-get install -y zsh

# Install basic dependencies
echo_info "Installing basic dependencies..."
apt-get install -y curl git wget unzip gnupg

# Install Neovim
echo_info "Installing Neovim..."
apt-get install -y neovim

# Install eza (modern ls replacement)
echo_info "Installing eza..."
mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
apt-get update
apt-get install -y eza

# Install fzf
echo_info "Installing fzf..."
if [ -d ~/.fzf ]; then
  echo_info "fzf already installed, updating..."
  cd ~/.fzf && git pull
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
fi
~/.fzf/install --all --no-bash --no-fish

# Add .local/bin to PATH for the installers
export PATH="$HOME/.local/bin:$PATH"

# Install zoxide
echo_info "Installing zoxide..."
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Install oh-my-posh
echo_info "Installing oh-my-posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s

# Install Zinit
echo_info "Installing Zinit..."
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ -d "$ZINIT_HOME" ]; then
  echo_info "Zinit already installed, updating..."
  cd "$ZINIT_HOME" && git pull
else
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Create .zshrc
echo_info "Creating .zshrc configuration..."
cat > ~/.zshrc << 'ZSHRC_EOF'
# Set Zsh history options
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory extendedglob
setopt hist_ignore_all_dups hist_save_no_dups hist_ignore_space
setopt nonomatch

# Enable Emacs Keybindings
bindkey -e

# Load Zinit
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
else
  echo "Warning: Zinit not found at ${ZINIT_HOME}/zinit.zsh"
fi

### Zinit Plugins ###
# Load plugins in the correct order for compatibility
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting # Must be last!

# Manually initialize the completion system BEFORE cdreplay
autoload -U compinit && compinit

# Now, replay the completion definitions
zinit cdreplay -q

# Set environment variables
export PATH="$HOME/.fzf/bin:$HOME/.local/bin:$PATH"

### Aliases ###
alias vim='nvim'
alias c='clear'

# Detect if terminal supports Nerd Fonts for icons
if [[ -n "$KITTY_WINDOW_ID" ]] || [[ -n "$ALACRITTY_SOCKET" ]] || [[ -n "$WEZTERM_EXECUTABLE" ]] || [[ -n "$GHOSTTY_RESOURCES_DIR" ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]] || [[ "$TERM_PROGRAM" == "WezTerm" ]] || [[ "$TERM_PROGRAM" == "vscode" ]]; then
  # Terminal supports Nerd Fonts - use icons
  alias ls='eza --icons'
  export NERD_FONTS=1
else
  # Basic terminal - no icons
  alias ls='eza'
  export NERD_FONTS=0
fi

### Shell Integrations & Final Evals ###
# These should generally come at the end of the file.

# Oh My Posh - Tokyo Night Storm theme
if [[ "$NERD_FONTS" == "1" ]]; then
  # Terminal supports Nerd Fonts - use icon version
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/tokyo-night-storm.omp.json)"
else
  # Fallback to plain version without icons (for Proxmox console, basic terminals)
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/tokyo-night-storm-plain.omp.json)"
fi

# Other tools
eval "$(zoxide init zsh)"

# fzf - source the integration file created by fzf installer
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
ZSHRC_EOF

# Download oh-my-posh Tokyo Night Storm themes (both icon and plain versions)
echo_info "Setting up oh-my-posh Tokyo Night Storm theme..."
mkdir -p ~/.config/oh-my-posh
curl -s https://raw.githubusercontent.com/timk75/lxc_zsh/main/tokyo-night-storm.omp.json -o ~/.config/oh-my-posh/tokyo-night-storm.omp.json
curl -s https://raw.githubusercontent.com/timk75/lxc_zsh/main/tokyo-night-storm-plain.omp.json -o ~/.config/oh-my-posh/tokyo-night-storm-plain.omp.json

# Change default shell to ZSH
echo_info "Changing default shell to ZSH..."
chsh -s $(which zsh)

echo_info "Setup complete!"
echo_warn "Please log out and log back in for the shell change to take effect."
echo_info "Or run: exec zsh"
