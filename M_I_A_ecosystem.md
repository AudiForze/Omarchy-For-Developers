# My Own Arch Configuration 

This is the full whrite-up about how i personalizes my arch linux, using son skill that i develop and focus to be more confortable as posible, practice and productive.

## Omarchy Set-up                           
During the installation i have to edit /etc/pacman.conf with cat to write a new path to Core, Extra, Multlib. Loocking for https://pkgbuild.com/[Extra/multilib/core]/os/_x86-X64

### Autoscale and resolution

```bash
# See https://wiki.hypr.land/Configuring/Basics/Monitors/
# List current monitors and resolutions possible: hyprctl monitors
# Format: monitor = [port], resolution, position, scale

# Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.
env = GDK_SCALE,2
monitor=,preferred,auto,auto

# Good compromise for 27" or 32" 4K monitors (but fractional!)
# env = GDK_SCALE,1.75
# monitor=,preferred,auto,1.6

# Straight 1x setup for low-resolution displays like 1080p or 1440p
# Or for ultrawide monitors like 34" 3440x1440 or 49" 5120x1440
# env = GDK_SCALE,1
# monitor=,preferred,auto,1

# Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°)
# monitor = DP-2, preferred, auto, 1, transform, 1

# Example for Framework 13 w/ 6K XDR Apple display
#monitor = HDMI_-A-1, 1920x31080@60, auto, 2
monitor = eDP-1, 1920x1080@60, auto, 1

# Disable the second ghost monitor on an Apple 6K XDR over Thunderbolt
# monitor=DP-2,disable
````

### Accounts

open google, github, aritable, notion, discord, ws etc 

### Download Github Repos

Downloads all my repos to start working as i can 

### Theme

Create or select the theme that we gonna use. In my case, i use Aether to create my own themes using a image that i browse

### Code and devolp apps 

sudo pacman -S code
python -m venv .venv
source .venv/bin/activate
yay -S ngrok


### Install Mia Workspace
Secrete Value but you can also use claude code

### 
