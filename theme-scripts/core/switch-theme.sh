#!/bin/bash

# Theme Switcher with Stow
# Flexible system: colors mandatory, overrides optional per theme

THEMES_DIR="$HOME/dotfiles/themes"
CURRENT_THEME_FILE="$HOME/.current-theme"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

# Get current theme
CURRENT_THEME=$(cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "matugen")

# Build theme list
get_themes() {
  echo "matugen"
  find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "matugen" ! -name "Wallpapers" ! -name "omarchy" -exec basename {} \; | sort
}

# Rofi menu
if [ -f "$ROFI_CONFIG" ]; then
  SELECTED=$(get_themes | rofi -i -dmenu -p "Select Theme" -config "$ROFI_CONFIG")
else
  SELECTED=$(get_themes | rofi -i -dmenu -p "Select Theme")
fi

# Exit if nothing selected
[ -z "$SELECTED" ] && exit 0

# Exit if same theme
[ "$SELECTED" = "$CURRENT_THEME" ] && {
  notify-send "Theme" "Already using $SELECTED"
  exit 0
}

# Switch themes
if [ "$SELECTED" = "matugen" ] || [ -d "$THEMES_DIR/$SELECTED" ]; then
  # Temporarily disable Hyprland's auto-reload to prevent errors during theme switching
  hyprctl keyword misc:disable_autoreload 1 >/dev/null 2>&1
  
  # Save selected theme
  echo "$SELECTED" >"$CURRENT_THEME_FILE"
  
  # Update Symphony current directory - mirror entire theme structure
  SYMPHONY_CURRENT="$HOME/.config/symphony/current"
  
  # Remove old current directory and recreate
  rm -rf "$SYMPHONY_CURRENT"
  mkdir -p "$SYMPHONY_CURRENT"
  
  # Symlink entire theme directory structure to current
  if [ -d "$THEMES_DIR/$SELECTED" ]; then
    # Create symlinks for all subdirectories and files
    find "$THEMES_DIR/$SELECTED" -mindepth 1 -maxdepth 1 | while read -r item; do
      item_name=$(basename "$item")
      ln -sf "$item" "$SYMPHONY_CURRENT/$item_name"
    done
  fi
  
  # Save current theme name
  echo "$SELECTED" > "$HOME/.config/symphony/.current-theme"
  
  # Symlink app configs to symphony/current (single source of truth)
  # This way we only update symphony/current when switching themes
  
  # Rofi colors
  if [ -f "$SYMPHONY_CURRENT/.config/rofi/colors.rasi" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/rofi/colors.rasi" "$HOME/.config/rofi/colors.rasi"
  fi
  
  # Starship config
  if [ -f "$SYMPHONY_CURRENT/.config/starship.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/starship.toml" "$HOME/.config/starship.toml"
  fi
  
  # Hyprland theme files
  mkdir -p "$HOME/.config/hypr/theme"
  if [ -f "$SYMPHONY_CURRENT/.config/hypr/theme/colors.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/hypr/theme/colors.conf" "$HOME/.config/hypr/theme/colors.conf"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/hypr/theme/overrides.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/hypr/theme/overrides.conf" "$HOME/.config/hypr/theme/overrides.conf"
  fi
  
  # Kitty theme files
  if [ -f "$SYMPHONY_CURRENT/.config/kitty/colors.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/kitty/colors.conf" "$HOME/.config/kitty/colors.conf"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/kitty/overrides.conf" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/kitty/overrides.conf" "$HOME/.config/kitty/overrides.conf"
  fi
  
  # Alacritty theme files
  if [ -f "$SYMPHONY_CURRENT/.config/alacritty/colors.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/alacritty/colors.toml" "$HOME/.config/alacritty/colors.toml"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/alacritty/overrides.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/alacritty/overrides.toml" "$HOME/.config/alacritty/overrides.toml"
  fi
  
  # Ghostty theme files
  mkdir -p "$HOME/.config/ghostty/themes"
  if [ -f "$SYMPHONY_CURRENT/.config/ghostty/themes/colors" ]; then
    # Matugen uses themes/colors path
    ln -sf "$SYMPHONY_CURRENT/.config/ghostty/themes/colors" "$HOME/.config/ghostty/themes/colors"
  elif [ -f "$SYMPHONY_CURRENT/.config/ghostty/theme" ]; then
    # Static themes use theme file (needs to be linked to themes/colors)
    ln -sf "$SYMPHONY_CURRENT/.config/ghostty/theme" "$HOME/.config/ghostty/themes/colors"
  fi
  
  # Btop theme file
  mkdir -p "$HOME/.config/btop/themes"
  if [ -f "$SYMPHONY_CURRENT/.config/btop/themes/current.theme" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/btop/themes/current.theme" "$HOME/.config/btop/themes/current.theme"
  fi
  
  # Update cava colors directly in config
  if [ -f "$SYMPHONY_CURRENT/.config/cava/colors.ini" ] || [ -f "$SYMPHONY_CURRENT/.config/cava" ]; then
    "$HOME/dotfiles/theme-scripts/core/update-cava-colors.sh" "$SELECTED" >/dev/null 2>&1
  fi
  
  # Update rmpc theme
  if [ -f "$SYMPHONY_CURRENT/.config/rmpc/themes/theme.ron" ] || [ -f "$SYMPHONY_CURRENT/.config/rmpc/themes/current.ron" ]; then
    "$HOME/dotfiles/theme-scripts/core/update-rmpc-theme.sh" "$SELECTED" >/dev/null 2>&1
  fi
  
  # Update Obsidian theme for all vaults
  bash "$HOME/dotfiles/theme-scripts/core/update-obsidian-theme.sh" >/dev/null 2>&1
  
  # Waybar colors
  if [ -f "$SYMPHONY_CURRENT/.config/waybar/colors.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/waybar/colors.css" "$HOME/.config/waybar/colors.css"
  fi
  
  # Vesktop theme file
  mkdir -p "$HOME/.config/vesktop/themes"
  if [ -f "$SYMPHONY_CURRENT/.config/vesktop/themes/midnight-discord.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/vesktop/themes/midnight-discord.css" "$HOME/.config/vesktop/themes/midnight-discord.css"
  fi
  
  # GTK colors
  if [ -f "$SYMPHONY_CURRENT/.config/gtk-3.0/colors.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/gtk-3.0/colors.css" "$HOME/.config/gtk-3.0/colors.css"
  fi
  if [ -f "$SYMPHONY_CURRENT/.config/gtk-4.0/colors.css" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/gtk-4.0/colors.css" "$HOME/.config/gtk-4.0/colors.css"
  fi
  
  # Pywal colors for Firefox pywalfox integration
  mkdir -p "$HOME/.cache/wal"
  if [ -f "$SYMPHONY_CURRENT/.cache/wal/colors.json" ]; then
    ln -sf "$SYMPHONY_CURRENT/.cache/wal/colors.json" "$HOME/.cache/wal/colors.json"
  fi
  
  # Yazi theme
  if [ -f "$SYMPHONY_CURRENT/.config/yazi/theme.toml" ]; then
    ln -sf "$SYMPHONY_CURRENT/.config/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"
  fi
  
  # Copy neovim theme for hot-reload (copy instead of symlink so LazyVim detects changes)
  if [ -f "$SYMPHONY_CURRENT/.config/nvim/theme.lua" ]; then
    cp "$SYMPHONY_CURRENT/.config/nvim/theme.lua" "$HOME/.config/nvim/lua/plugins/theme-current.lua"
  else
    # Remove file if theme doesn't have nvim theme (uses default colorscheme.lua)
    rm -f "$HOME/.config/nvim/lua/plugins/theme-current.lua"
  fi
  
  # Re-enable auto-reload
  hyprctl keyword misc:disable_autoreload 0 >/dev/null 2>&1

  # Apply GTK dark theme using nwg-look (reads from gsettings and applies properly)
  nwg-look -a >/dev/null 2>&1

  # Get wallpaper if theme has one (sorted for consistency)
  WALLPAPER=$(find "$THEMES_DIR/$SELECTED/backgrounds" -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | sort | head -1)

  # Set wallpaper if exists
  if [ -n "$WALLPAPER" ]; then
    swww query &>/dev/null || swww-daemon --format xrgb &
    swww img "$WALLPAPER" --transition-fps 60 --transition-type=any --transition-duration=1
  fi
  
  # Always update wallpaper symlink to whatever swww is currently displaying
  mkdir -p "$HOME/.config/symphony/current"
  CURRENT_WALLPAPER=$(swww query 2>/dev/null | grep "currently displaying" | head -1 | sed 's/.*image: //')
  if [ -n "$CURRENT_WALLPAPER" ]; then
    ln -sf "$CURRENT_WALLPAPER" "$HOME/.config/symphony/current/wallpaper"
  fi

  # Reload all apps
  hyprctl reload 2>/dev/null
  killall -SIGUSR1 kitty 2>/dev/null
  pkill -SIGUSR1 alacritty 2>/dev/null
  pkill -SIGUSR2 btop 2>/dev/null
  pkill -SIGUSR2 waybar 2>/dev/null
  swaync-client -rs 2>/dev/null
  ghostty +reload-config 2>/dev/null
  killall -SIGUSR2 ghostty 2>/dev/null
  
  # Force Starship reload by touching the config file (triggers inotify)
  touch "$HOME/.config/starship.toml" 2>/dev/null

  # Reload GTK apps
  pgrep -x nautilus >/dev/null && (
    pkill -x nautilus && nautilus &>/dev/null &
    disown
  )

  # Update Firefox pywalfox colors automatically
  pywalfox update >/dev/null 2>&1 &

  # Send notification
  if [ -n "$WALLPAPER" ]; then
    notify-send -i "$WALLPAPER" "Theme Applied" "Switched to: $SELECTED"
  else
    notify-send "Theme Applied" "Switched to: $SELECTED"
  fi
else
  notify-send "Error" "Theme not found: $SELECTED"
  exit 1
fi
