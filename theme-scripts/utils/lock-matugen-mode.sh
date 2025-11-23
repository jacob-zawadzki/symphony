#!/bin/bash
#
# Symphony - Matugen Lock
# Adds locks to wallpaper scripts to prevent color changes on static themes
# Usage: ./lock-matugen-mode.sh
# https://github.com/vyrx-dev

SELECTWALL="$HOME/.config/rofi/scripts/selectWall"
WALLPICKER="$HOME/.config/rofi/scripts/wallPicker"
CHANGETHEME="$HOME/.config/hypr/scripts/change-theme"

echo "Adding locks to wallpaper scripts..."
echo ""

# The lock code we'll inject
LOCK_CODE='
# Check if custom theme is active
CURRENT_THEME=$(cat ~/.config/symphony/.current-theme 2>/dev/null || echo "matugen")
if [[ "$CURRENT_THEME" != "matugen" ]]; then
    notify-send "Theme Locked" "Using custom theme: $CURRENT_THEME\\nSwitch to Matugen to change themes"
    exit 0
fi
'

# Lock selectWall (matugen color picker)
if [[ -f "$SELECTWALL" ]]; then
  cp "$SELECTWALL" "${SELECTWALL}.backup"
  sed -i "2i\\$LOCK_CODE" "$SELECTWALL"
  echo "[OK] selectWall - locked"
else
  echo "[SKIP] selectWall not found"
fi

# Add note to wallPicker (doesn't need lock, just changes wallpaper)
if [[ -f "$WALLPICKER" ]]; then
  cp "$WALLPICKER" "${WALLPICKER}.backup"
  sed -i '2i\\n# Note: This only changes wallpaper, not theme colors' "$WALLPICKER"
  echo "[OK] wallPicker - note added"
else
  echo "[SKIP] wallPicker not found"
fi

# Lock change-theme
if [[ -f "$CHANGETHEME" ]]; then
  cp "$CHANGETHEME" "${CHANGETHEME}.backup"
  sed -i "2i\\$LOCK_CODE" "$CHANGETHEME"
  echo "[OK] change-theme - locked"
else
  echo "[SKIP] change-theme not found"
fi

echo ""
echo "Done! Matugen scripts are now locked when using static themes."
echo ""
echo "Backups: *.backup (restore with: mv script.backup script)"
