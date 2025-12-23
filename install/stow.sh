#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| Stow Symlinks       |-/ /--|#
#|/ /---+---------------------+/ /---|#

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

step "Linking dotfiles"

# Backup existing configs that would conflict
backup_items=(
    .config/hypr
    .config/waybar
    .config/rofi
    .config/kitty
    .config/fish/config.fish
)

for item in "${backup_items[@]}"; do
    if [[ -e "$HOME/$item" && ! -L "$HOME/$item" ]]; then
        mkdir -p "$(dirname "$HOME/$item.bak")"
        mv "$HOME/$item" "$HOME/$item.bak"
        info "Backed up $item"
    fi
done

# Stow dotfiles
cd "$DOTFILES"
output=$(stow -v . 2>&1)

if echo "$output" | grep -q "WARNING\|ERROR\|cannot stow"; then
    echo "$output" | grep -v "^LINK:"
    warn "Conflicts detected - check above"
    info "Fix conflicts and run: cd ~/dotfiles && stow ."
else
    ok "Dotfiles linked"
fi
true
