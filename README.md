# 🐧 Omarchy Setup Guide

> **Omarchy** is a pre-configured Arch Linux distribution developed by DHH, based on **Hyprland** (a Wayland compositor), designed for developers who value tiled window management, keyboard-controlled workflows, and a minimalist yet powerful environment.

This guide covers the complete setup from installation to daily customization, plus a dedicated **Developers** section with a modern Python development stack.

---

## 📋 Table of Contents

- [System Requirements](#-system-requirements)
- [Installation](#-installation)
- [Post-Installation](#-post-installation)
- [Customization](#-customization)
- [Daily Workflow & Hotkeys](#-daily-workflow--hotkeys)
- [Developers](#-developers)
- [Troubleshooting](#-troubleshooting)

---

## 🖥️ System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **Storage** | 64 GB | 256 GB SSD |
| **RAM** | 4 GB | 8 GB+ |
| **USB Drive** | 8 GB | 16 GB |
| **Internet** | Ethernet or Wi-Fi | Ethernet for faster install |

> ⚠️ **Important:** You must **disable Secure Boot and TPM** in your BIOS/UEFI before installation. Omarchy handles disk encryption and auto-login after decryption.

---

## 💾 Installation

### 1. Download the ISO

Download the latest Omarchy ISO from [omarchy.org](https://omarchy.org). The image is typically around **6–7 GB**.

### 2. Create a Bootable USB

Use **Ventoy**, **BalenaEtcher**, or **Rufus** (Windows) to flash the ISO to your USB drive.

```bash
# Linux example with dd (replace /dev/sdX with your USB device)
sudo dd if=omarchy.iso of=/dev/sdX bs=4M status=progress && sync
```

### 3. Boot & Install

1. Insert the USB and boot from it (select USB in BIOS boot menu).
2. The installer will launch automatically.
3. Enter your details when prompted:
   - **Username** — your login name
   - **Password** — used for login, root, and disk encryption
   - **Full name** — used for Git configuration
   - **Email** — used for Git configuration
   - **Hostname** — machine name (defaults to `omarchy`)
   - **Timezone** — e.g., `America/New_York`, `Europe/Madrid`
   - **Keyboard layout** — e.g., `us`, `es`, `jp`
4. Select your installation disk and confirm formatting.
5. Wait for the automated installation to complete (typically **5–15 minutes** depending on your drive speed).
6. Reboot when prompted and remove the USB.

---

## 🔧 Post-Installation

### First Boot

After reboot, you'll land directly on the Hyprland desktop (no login screen needed thanks to disk encryption auto-login).

### Update the System

Omarchy is Arch-based, so use `pacman` and the Arch User Repository (AUR):

```bash
# Update all system packages
sudo pacman -Syu

# Install yay (AUR helper) if not present
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### Essential First Steps

1. **Set up Wi-Fi** (if not using Ethernet):
   ```bash
   nmcli device wifi list
   nmcli device wifi connect "SSID" password "your_password"
   ```

2. **Verify Git configuration** (set during install):
   ```bash
   git config --global user.name
   git config --global user.email
   ```

3. **Install your preferred browser** (Chromium is pre-installed):
   ```bash
   yay -S firefox  # or brave, zen-browser
   ```

---

## 🎨 Customization

### Window Manager: Hyprland

Hyprland config lives at `~/.config/hypr/`. Key files:

| File | Purpose |
|------|---------|
| `~/.config/hypr/hyprland.conf` | Main configuration |
| `~/.config/hypr/input.conf` | Keyboard and mouse settings |
| `~/.config/hypr/monitors.conf` | Display settings |

### Fix Caps Lock Behavior

By default, Omarchy remaps **Caps Lock** to a compose key for emoji and special character input. To restore normal Caps Lock:

```bash
nvim ~/.config/hypr/input.conf
```

Change:
```ini
kb_options = compose:caps
```
To:
```ini
kb_options = compose:ralt   # Use Right Alt as compose key instead
```

Then reload Hyprland: `SUPER + SHIFT + R`

### Disable Screensaver

Open the Omarchy menu (`SUPER + ALT + Space` → **Toggle** → **Screensaver**).

### Terminal: Alacritty

The default terminal is **Alacritty**. Config at `~/.config/alacritty/alacritty.toml`.

---

## ⌨️ Daily Workflow & Hotkeys

Omarchy is built for keyboard-driven workflows. Here are the essentials:

| Hotkey | Action |
|--------|--------|
| `SUPER + Return` | Open terminal (Alacritty) |
| `SUPER + ALT + Space` | Open app launcher/menu |
| `SUPER + W` | Close focused window |
| `SUPER + SHIFT + B` | Open Chromium |
| `SUPER + SHIFT + F` | Open file manager |
| `SUPER + [1-9]` | Switch to workspace N |
| `SUPER + SHIFT + [1-9]` | Move window to workspace N |
| `SUPER + J/K` | Focus next/previous window |
| `SUPER + SHIFT + R` | Reload Hyprland config |
| `SUPER + Q` | Quit Hyprland |

> 💡 **Pro tip:** Spend your first week using only the keyboard. The tiling WM becomes muscle memory quickly and dramatically boosts productivity.

---

## 👨‍💻 Developers

This section covers setting up a modern Python development environment on Omarchy, using **uv** — the fastest and most unified Python toolchain available in 2026.

### Why `uv`?

`uv` (by Astral, the team behind Ruff) replaces `pip`, `venv`, `virtualenv`, `pip-tools`, `pyenv`, and `pipx` in a single Rust-based binary. It is **10–100x faster** than pip and works identically across platforms.

### 1. Install `uv`

```bash
# Install via the official installer
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or via pacman (if available in repos)
sudo pacman -S uv
```

Reload your shell or run:
```bash
source $HOME/.local/bin/env
```

Verify:
```bash
uv --version
```

### 2. Install Python Versions

```bash
# Install the latest stable Python
uv python install 3.13

# Install multiple versions
uv python install 3.11 3.12 3.13

# List available/installed versions
uv python list
```

### 3. Create a New Project

```bash
# Initialize a new project
uv init my-project
cd my-project

# Pin a specific Python version for this project
uv python pin 3.13
```

This creates:
- `pyproject.toml` — project metadata and dependencies
- `uv.lock` — deterministic lockfile for reproducible builds
- `.python-version` — Python version for this directory

### 4. Manage Dependencies

```bash
# Add production dependencies
uv add fastapi "uvicorn[standard]" httpx

# Add development dependencies
uv add --dev pytest ruff mypy

# Install from requirements.txt (legacy support)
uv pip install -r requirements.txt

# Sync environment to match lockfile
uv sync
```

### 5. Run Your Code

```bash
# Run a script (automatically uses the project's venv)
uv run python main.py

# Run tests
uv run pytest

# Run a tool without installing it globally
uvx ruff check .
uvx black --check .
```

> 🚀 **No manual venv activation needed!** `uv run` automatically detects and uses the `.venv` in your project directory.

### 6. Install Global CLI Tools

```bash
# Install tools globally (similar to pipx)
uv tool install httpie
uv tool install ruff

# Run a tool once without installing
uvx ipython
```

### 7. Recommended VS Code: Setup

Install these extensions for the best Python experience:

| Extension | Purpose |
|-----------|---------|
| Python (Microsoft) | Core Python support |
| Pylance | Advanced language server |
| Ruff | Linting and formatting (replaces Black + Flake8) |
| Even Better TOML | `pyproject.toml` support |

**Settings (`settings.json`):**
```json
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python",
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "charliermarsh.ruff",
  "ruff.lint.run": "onSave"
}
```

### 8. Complete Developer Toolkit

```bash
# Core Python stack
uv add --dev pytest pytest-cov mypy ruff

# Web development
uv add fastapi "uvicorn[standard]" httpx sqlalchemy

# Data science
uv add pandas numpy matplotlib polars

# CLI enhancements
uv add rich textual
```

### 9. Docker Integration (Optional)

For containerized workflows, use `uv` inside Docker for faster builds:

```dockerfile
FROM python:3.13-slim AS builder
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev

FROM python:3.13-slim
COPY --from=builder /.venv /.venv
COPY src/ ./src/
CMD ["/.venv/bin/python", "-m", "myapp"]
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| **Black screen after install** | Check GPU drivers; Intel/AMD usually work out of the box. For NVIDIA, install `nvidia` and `nvidia-utils`. |
| **No Wi-Fi** | Install `iwd` or `networkmanager` and enable the service: `sudo systemctl enable --now NetworkManager` |
| **Bluetooth keyboard during encryption** | Use a wired or 2.4GHz dongle keyboard for disk unlock; Bluetooth initializes later. |
| **Caps Lock not working** | See [Customization > Fix Caps Lock Behavior](#fix-caps-lock-behavior) |
| **Apps not launching** | Check Hyprland logs: `cat ~/.hyprland/hyprland.log` |

---

## 📚 Resources

- [Omarchy Official Site](https://omarchy.org)
- [Hyprland Wiki](https://wiki.hyprland.org)
- [Arch Wiki](https://wiki.archlinux.org)
- [uv Documentation](https://docs.astral.sh/uv/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)

---

> 📝 **Last updated:** June 2026  
> **Maintained by:** [Your Name]
