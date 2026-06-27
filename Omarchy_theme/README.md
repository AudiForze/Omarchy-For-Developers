# Omarchy Developers Theme

Place your custom Omarchy theme files in this directory.

## Expected Structure

```
Omarchy_theme/
├── gtk/                    # GTK theme files
│   └── ...
├── icons/                  # Icon theme
│   └── ...
├── cursors/                # Cursor theme
│   └── ...
├── hypr/                   # Hyprland config overrides
│   ├── hyprland.conf
│   └── ...
├── waybar/                 # Waybar theme/config
│   ├── config
│   └── style.css
├── wofi/                   # Wofi launcher theme
│   └── style.css
├── alacritty/              # Terminal theme
│   └── alacritty.toml
├── dunst/                  # Notification daemon theme
│   └── dunstrc
└── install.sh              # (Optional) Custom installer script
```

## How It Works

The `install.sh` script in the parent directory will:

1. Detect which subdirectories exist in this folder
2. Copy theme files to the appropriate `~/.config/` or `~/.themes/` locations
3. Run a custom `install.sh` if present inside this folder

## Tips

- Only include the files you want to override; missing directories will be skipped.
- If your theme is a single packaged theme (e.g., a GTK theme with everything inside one folder), just place all files here directly.
- For Hyprland colors and aesthetics, you typically want to modify:
  - `~/.config/hypr/hyprland.conf` (general settings, gaps, borders)
  - `~/.config/waybar/style.css` (top bar styling)
  - `~/.config/wofi/style.css` (app launcher styling)
  - `~/.config/alacritty/alacritty.toml` (terminal colors)

## Theme Name

The theme will be installed as: `omarchy-omarchy_developers-theme`
