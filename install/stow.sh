#!/bin/bash
# Symlink dotfiles using stow

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Directories that commonly conflict (exist from fresh installs)
CONFLICT_DIRS=(
    ".config/hypr"
    ".config/waybar"
    ".config/rofi"
    ".config/kitty"
    ".config/fish"
)

backup_conflicts() {
    local backup_made=0
    for dir in "${CONFLICT_DIRS[@]}"; do
        local target="$HOME/$dir"
        # Skip if doesn't exist or is already a symlink
        [[ -e "$target" && ! -L "$target" ]] || continue
        
        local backup="$target.bak"
        # Remove old backup if exists
        [[ -e "$backup" ]] && rm -rf "$backup"
        
        mv "$target" "$backup"
        info "Backed up $dir → $dir.bak"
        backup_made=1
    done
    [[ $backup_made -eq 1 ]] && echo
    return 0
}

step "Linking dotfiles"

# Backup existing configs that would conflict
backup_conflicts

cd "$DOTFILES"

if stow . 2>&1 | grep -q "conflicts"; then
    warn "Conflicts detected"
    # Show what's conflicting
    stow . 2>&1 | grep "existing target" | head -5
    err "Please resolve conflicts manually or remove conflicting files"
    return 1 2>/dev/null || exit 1
fi

stow . || { err "Stow failed"; return 1 2>/dev/null || exit 1; }
ok "Dotfiles linked"
