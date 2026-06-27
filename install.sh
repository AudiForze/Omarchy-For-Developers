#!/bin/bash
###############################################################################
# Omarchy Post-Installation Setup Script
# 
# This script automates the customization of a fresh Omarchy installation:
#   - Updates the system
#   - Installs Brave browser and Visual Studio Code:
#   - Sets up the Omarchy Developers theme
#   - Installs and configures uv (Python toolchain)
#   - Installs essential developer tools
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
###############################################################################

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging helpers
log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Script directory (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$SCRIPT_DIR/Omarchy_theme"

###############################################################################
# 1. System Update
###############################################################################
log_info "Updating system packages..."
sudo pacman -Syu --noconfirm
log_ok "System updated."

###############################################################################
# 2. Install yay (AUR helper) if not present
###############################################################################
if ! command -v yay &> /dev/null; then
    log_info "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm git base-devel

    # Clone and build yay in /tmp to avoid polluting home
    YAY_BUILD_DIR="/tmp/yay-build-$$"
    git clone https://aur.archlinux.org/yay.git "$YAY_BUILD_DIR"
    cd "$YAY_BUILD_DIR"
    makepkg -si --noconfirm
    cd -
    rm -rf "$YAY_BUILD_DIR"
    log_ok "yay installed."
else
    log_ok "yay is already installed."
fi

###############################################################################
# 3. Install Brave Browser
###############################################################################
log_info "Installing Brave Browser..."
if ! command -v brave &> /dev/null; then
    yay -S --noconfirm brave-bin
    log_ok "Brave Browser installed."
else
    log_ok "Brave Browser is already installed."
fi

###############################################################################
# 4. Install Visual Studio Code:
###############################################################################
log_info "Installing Visual Studio Code:..."
if ! command -v code &> /dev/null; then
    yay -S --noconfirm visual-studio-code-bin
    log_ok "Visual Studio Code: installed."
else
    log_ok "Visual Studio Code: is already installed."
fi

###############################################################################
# 5. Install Omarchy Developers Theme
###############################################################################
log_info "Installing Omarchy Developers Theme..."

if [ ! -d "$THEME_DIR" ]; then
    log_error "Theme directory not found: $THEME_DIR"
    log_warn "Please ensure the Omarchy_theme folder is in the same directory as this script."
    exit 1
fi

# Determine theme type and install accordingly
THEME_NAME="omarchy-omarchy_developers-theme"

# GTK theme
if [ -d "$THEME_DIR/gtk" ] || [ -f "$THEME_DIR/gtk.css" ] || ls "$THEME_DIR"/*.css 1> /dev/null 2>&1; then
    log_info "Installing GTK theme..."
    mkdir -p ~/.themes
    cp -r "$THEME_DIR" ~/.themes/"$THEME_NAME"
    log_ok "GTK theme installed to ~/.themes/$THEME_NAME"
fi

# Icon theme
if [ -d "$THEME_DIR/icons" ] || [ -d "$THEME_DIR/icon-theme" ]; then
    log_info "Installing icon theme..."
    mkdir -p ~/.icons
    if [ -d "$THEME_DIR/icons" ]; then
        cp -r "$THEME_DIR/icons" ~/.icons/"$THEME_NAME"
    else
        cp -r "$THEME_DIR" ~/.icons/"$THEME_NAME"
    fi
    log_ok "Icon theme installed to ~/.icons/$THEME_NAME"
fi

# Cursor theme
if [ -d "$THEME_DIR/cursors" ]; then
    log_info "Installing cursor theme..."
    mkdir -p ~/.icons
    cp -r "$THEME_DIR" ~/.icons/"$THEME_NAME-cursor"
    log_ok "Cursor theme installed to ~/.icons/$THEME_NAME-cursor"
fi

# Hyprland / Waybar theme files
if [ -d "$THEME_DIR/hypr" ] || [ -d "$THEME_DIR/waybar" ] || [ -d "$THEME_DIR/wofi" ]; then
    log_info "Installing Hyprland theme components..."

    [ -d "$THEME_DIR/hypr" ] && cp -r "$THEME_DIR/hypr/"* ~/.config/hypr/ 2>/dev/null || true
    [ -d "$THEME_DIR/waybar" ] && cp -r "$THEME_DIR/waybar/"* ~/.config/waybar/ 2>/dev/null || true
    [ -d "$THEME_DIR/wofi" ] && cp -r "$THEME_DIR/wofi/"* ~/.config/wofi/ 2>/dev/null || true
    [ -d "$THEME_DIR/alacritty" ] && cp -r "$THEME_DIR/alacritty/"* ~/.config/alacritty/ 2>/dev/null || true
    [ -d "$THEME_DIR/dunst" ] && cp -r "$THEME_DIR/dunst/"* ~/.config/dunst/ 2>/dev/null || true

    log_ok "Hyprland theme components installed."
fi

# If theme is a single directory with standard structure, copy everything
if [ -f "$THEME_DIR/install.sh" ]; then
    log_info "Theme has its own installer, running it..."
    cd "$THEME_DIR"
    bash install.sh
    cd -
fi

log_ok "Theme installation complete."

###############################################################################
# 6. Install uv (Python toolchain)
###############################################################################
log_info "Installing uv (Python toolchain)..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Add uv to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"

    # Ensure uv is in shell profile
    for PROFILE in ~/.bashrc ~/.zshrc; do
        if [ -f "$PROFILE" ] && ! grep -q ".local/bin/env" "$PROFILE" 2>/dev/null; then
            echo 'source "$HOME/.local/bin/env"' >> "$PROFILE"
            log_info "Added uv to $PROFILE"
        fi
    done

    log_ok "uv installed."
else
    log_ok "uv is already installed."
fi

# Verify uv
uv --version

###############################################################################
# 7. Install Python versions via uv
###############################################################################
log_info "Installing Python 3.13 via uv..."
uv python install 3.13
log_ok "Python 3.13 installed."

###############################################################################
# 8. Install essential developer tools
###############################################################################
log_info "Installing essential developer tools..."

# Core tools from pacman
sudo pacman -S --needed --noconfirm     git     neovim     tmux     fzf     ripgrep     fd     bat     eza     zoxide     starship     docker     docker-compose

# Enable Docker service
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
log_ok "Docker installed and user added to docker group."

# Install global Python tools via uv
log_info "Installing global Python CLI tools..."
uv tool install ruff
uv tool install httpie
uv tool install ipython
log_ok "Global Python tools installed."

###############################################################################
# 9. Configure Git (if not already set)
###############################################################################
log_info "Checking Git configuration..."
if [ -z "$(git config --global user.name 2>/dev/null)" ]; then
    log_warn "Git user.name not set. Please configure it manually:"
    echo "  git config --global user.name 'Your Name'"
fi
if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
    log_warn "Git user.email not set. Please configure it manually:"
    echo "  git config --global user.email 'your@email.com'"
fi

###############################################################################
# 10. Final Steps & Summary
###############################################################################
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}  🎉 Omarchy setup complete!${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Installed packages:"
echo "  • Brave Browser"
echo "  • Visual Studio Code:"
echo "  • uv (Python toolchain)"
echo "  • Python 3.13"
echo "  • Docker & Docker Compose"
echo "  • Neovim, tmux, fzf, ripgrep, fd, bat, eza, zoxide, starship"
echo "  • Global Python tools: ruff, httpie, ipython"
echo ""
echo "Theme installed:"
echo "  • omarchy-omarchy_developers-theme"
echo ""
echo "Next steps:"
echo "  1. Log out and log back in (or reboot) to apply all changes."
echo "  2. Open a new terminal to load updated PATH."
echo "  3. Configure Git user.name and user.email if not set."
echo "  4. Launch Hyprland theme settings to activate the new theme."
echo "  5. Install VS Code: extensions for Python development."
echo ""
echo "Recommended VS Code: extensions:"
echo "  • Python (Microsoft)"
echo "  • Pylance"
echo "  • Ruff"
echo "  • Even Better TOML"
echo ""
echo "═══════════════════════════════════════════════════════════════"
