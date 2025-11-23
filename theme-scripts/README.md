# Symphony Theme System

##### ⚠️Warning  

> Read scripts before running. We are not responsible for any issues.  
> Create an issue at <https://github.com/vyrx-dev/dotfiles/issues> if you encounter problems.

## What is Symphony?

Unified theme switcher for Hyprland. Change colors, wallpapers, and app themes with one command.

## Quick Start

```bash
# Install
cd ~/dotfiles/theme-scripts
./install.sh

# Switch themes
symphony-theme switch

# Fix colors
symphony-theme fix
```

**Keyboard shortcuts** (in Hyprland):

- `SUPER+CTRL+SHIFT+SPACE` - Theme switcher
- `SUPER+ALT+LEFT/RIGHT` - Cycle wallpapers
- `SUPER+CTRL+SPACE` - Matugen picker (dynamic colors)

## How It Works

Symphony uses **symlinks** to connect theme files to your configs.

```
~/dotfiles/themes/zen/           → Theme storage
    ├── .config/kitty/colors.conf
    ├── .config/rofi/colors.rasi
    └── backgrounds/wallpaper.jpg

~/.config/                        → Active (symlinked)
    ├── kitty/colors.conf  → points to zen/
    └── rofi/colors.rasi   → points to zen/
```

When switching themes:

1. Remove old symlinks
2. Create new symlinks to selected theme
3. Change wallpaper
4. Reload apps

<details>
<summary><b>📦 Installation</b></summary>

### One-line install

```bash
cd ~/dotfiles/theme-scripts
./install.sh
```

The installer:

- Auto-detects `gum` (fancy UI)
- Falls back to plain mode if needed
- Creates `symphony-theme` command
- Offers theme selection

### After install - Reload your shell

**Bash:**

```bash
source ~/.bashrc
```

**Zsh:**

```bash
source ~/.zshrc
```

**Fish:**

```fish
source ~/.config/fish/config.fish
```

### Test it

```bash
symphony-theme switch
```

### First-time setup checklist

- [x] Run installer
- [x] Reload shell
- [x] Test theme switch
- [ ] Add wallpapers to theme backgrounds/
- [ ] Generate missing configs if needed

</details>

<details>
<summary><b>🎨 Adding New Themes</b></summary>

### Method 1: Copy Existing

```bash
# Copy template
cp -r ~/dotfiles/themes/zen ~/dotfiles/themes/my-theme

# Edit colors (most important file)
nvim ~/dotfiles/themes/my-theme/.config/kitty/colors.conf

# Add wallpaper
cp wallpaper.jpg ~/dotfiles/themes/my-theme/backgrounds/

# Generate other configs
cd ~/dotfiles/theme-scripts
./generate-configs --theme my-theme

# Test it
symphony-theme switch
```

### Method 2: From Scratch

```bash
# Create structure
mkdir -p ~/dotfiles/themes/my-theme/.config/kitty
mkdir ~/dotfiles/themes/my-theme/backgrounds

# Create kitty colors (16-color palette)
nvim ~/dotfiles/themes/my-theme/.config/kitty/colors.conf
```

**Kitty colors format:**

```conf
background       #0d0509
foreground       #f0eaed
color0           #1a1a1a    # black
color1           #ff5555    # red
color2           #50fa7b    # green
color3           #f1fa8c    # yellow
color4           #bd93f9    # blue
color5           #ff79c6    # magenta
color6           #8be9fd    # cyan
color7           #f8f8f2    # white
color8           #6272a4    # bright black
color9-15        # bright versions of 1-7
```

```bash
# Add wallpaper
cp wallpaper.jpg ~/dotfiles/themes/my-theme/backgrounds/

# Generate all other configs
cd ~/dotfiles/theme-scripts
./generate-configs --theme my-theme

# Test
symphony-theme switch
```

**What gets generated:**

- ✓ starship.toml (shell prompt)
- ✓ rofi/colors.rasi (launcher)
- ✓ cava-config (visualizer)
- ✓ rmpc/themes/theme.ron (music player)
- ✓ yazi/theme.toml (file manager)

</details>

<details>
<summary><b>⚙️ Config Generation</b></summary>

### Interactive Mode

```bash
cd ~/dotfiles/theme-scripts
./generate-configs
```

Shows missing configs and lets you generate them.

### Command Line

```bash
# Single theme
./generate-configs --theme zen

# All themes
./generate-configs --all

# Force regenerate
./generate-configs --theme zen --force
```

### How It Works

**Color Source Priority:**

1. `kitty/colors.conf` (preferred)
2. `btop/themes/*.theme` (fallback)
3. Skip if neither exists

**What It Does:**

- Extracts colors from source
- Generates missing configs
- Skips existing files (unless --force)
- Uses proper color schemes (learned from zen/sakura/gruvbox)

</details>

<details>
<summary><b>🗑️ Removing Themes</b></summary>

### Uninstall Script

```bash
cd ~/dotfiles/theme-scripts
./uninstall.sh
```

**Options:**

1. Delete specific themes (multi-select)
2. Complete removal (nuke everything)

### Manual Removal

```bash
# Switch to different theme first
symphony-theme switch

# Delete theme
rm -rf ~/dotfiles/themes/old-theme
```

</details>

<details>
<summary><b>🎯 Theme Modes</b></summary>

### Static Themes

- Fixed colors (zen, sakura, gruvbox, etc.)
- Change wallpaper anytime (`SUPER+ALT+SPACE`)
- Colors stay the same

### Matugen (Dynamic)

- Colors generated from wallpaper
- Material Design 3 system
- Auto-updates when wallpaper changes

**Switch to matugen:**

```bash
symphony-theme switch  # Select "matugen"
```

**Pick wallpaper:**

- `SUPER+CTRL+SPACE` - Matugen picker (generates colors)
- `CTRL+ALT+SPACE` - Random matugen wallpaper

**Note:** Matugen scripts are locked when using static themes (prevents accidental color changes).

</details>

<details>
<summary><b>🛠️ Commands</b></summary>

### Main Commands

| Command | Description |
|---------|-------------|
| `symphony-theme switch [theme]` | Switch themes (menu or direct) |
| `symphony-theme list` | Show installed themes |
| `symphony-theme remove <name>` | Remove a theme |
| `symphony-theme fix` | Fix broken symlinks |
| `symphony-theme generate` | Generate configs (interactive) |
| `symphony-theme version` / `-i` / `--info` | Show version and info |
| `symphony-theme help` | Show help |

### Scripts

```bash
cd ~/dotfiles/theme-scripts

# Generate configs
./generate-configs                    # Interactive
./generate-configs --theme zen        # Single theme
./generate-configs --all              # All themes

# Uninstall
./uninstall.sh                        # Remove themes/system

# Lock matugen mode
./utils/lock-matugen-mode.sh          # Add locks to wallpaper scripts (theme-switch will handle this)
```

</details>

<details>
<summary><b>🔧 Troubleshooting</b></summary>

### Colors look wrong

```bash
symphony-theme fix
```

### Theme won't switch

```bash
# Check current theme
cat ~/.config/symphony/.current-theme

# Manual switch
cd ~/dotfiles/themes
stow -D old-theme
stow new-theme
```

### Wallpaper picker blocked

- `wallPicker` (SUPER+ALT+SPACE) works with all themes
- `selectWall` (SUPER+CTRL+SPACE) only works in matugen mode
- Switch to matugen first if you want dynamic colors

### Config missing

```bash
cd ~/dotfiles/theme-scripts
./generate-configs --theme my-theme
```

</details>

<details>
<summary><b>📋 What's Included</b></summary>

Each theme has configs for:

| App | Config File | Colors From |
|-----|------------|-------------|
| Hyprland | `hypr/theme/colors.conf` | Manual |
| Kitty | `kitty/colors.conf` | **Source** |
| Alacritty | `alacritty/colors.toml` | Manual |
| Rofi | `rofi/colors.rasi` | kitty |
| Starship | `starship.toml` | kitty |
| Cava | `cava-config` | kitty |
| RMPC | `rmpc/themes/theme.ron` | kitty |
| Yazi | `yazi/theme.toml` | pywal |
| Btop | `btop/themes/*.theme` | Manual |
| Vesktop | `vesktop/themes/*.css` | Manual |

**Note:** `kitty/colors.conf` is the main color source for generators.

</details>

<details>
<summary><b>📁 Project Structure</b></summary>

```
theme-scripts/
├── core/                    # Main functionality
│   ├── switch-theme.sh     # Theme switcher
│   ├── fix-symlinks.sh     # Fix broken links
│   ├── update-cava-colors.sh
│   ├── update-rmpc-theme.sh
│   └── update-obsidian-theme.sh
│
├── utils/                   # Maintenance
│   └── lock-matugen-mode.sh # Lock matugen scripts
│
├── generate-configs         # Config generator
├── uninstall.sh            # Removal tool
├── install.sh              # Installer
├── symphony-theme          # Main command
└── README.md
```

**Key principles:**

- Auto-detection (no hardcoded theme lists)
- Smart fallbacks (kitty → btop → skip)
- Skip existing files (unless forced)
- Human-readable code

</details>

<details>
<summary><b>🤝 Contributing</b></summary>

This is a personal dotfiles project made public. Contributions welcome!

**Guidelines:**

- Keep it simple (no enterprise architecture)
- Maintain auto-detection (no hardcoded lists)
- Test with multiple themes
- Add clear documentation

**Code style:**

```bash
# Good: Auto-detects
for dir in "$THEMES_DIR"/*; do
  process_theme "$(basename "$dir")"
done

# Bad: Hardcoded
THEMES=("zen" "sakura")
```

</details>

---

<details>
<summary><b>❓ FAQ</b></summary>

### Q: Where are colors generated from?

A: `kitty/colors.conf` is the main source. Generators extract colors and create configs for other apps.

### Q: What if I only have btop colors?

A: Generators fall back to btop if kitty is missing.

### Q: Can I use my own wallpaper picker?

A: Yes! Just make sure it updates the symlink: `ln -sf "$WALLPAPER" "$THEME/wallpaper"`

### Q: Does this work with other window managers?

A: Core system works anywhere. Hyprland-specific parts are optional.

### Q: How do I add support for a new app?

A: Create generator that extracts from kitty/btop and outputs app config.

### Q: What's the difference between wallPicker and selectWall?

- `wallPicker`: Changes wallpaper only (works with all themes)
- `selectWall`: Changes wallpaper + generates colors (matugen only)

</details>

---

## File Reference

### Core Scripts

| File | Purpose |
|------|---------|
| `symphony-theme` | Main command entry point |
| `core/switch-theme.sh` | Theme switcher with menu |
| `core/fix-symlinks.sh` | Recreates all symlinks |
| `core/update-cava-colors.sh` | Updates Cava visualizer colors |
| `core/update-rmpc-theme.sh` | Updates RMPC music player theme |
| `core/update-obsidian-theme.sh` | Updates Obsidian note-taking theme |
| `core/generate-vesktop-themes.sh` | Generates Discord/Vesktop themes |

### Utilities

| File | Purpose |
|------|---------|
| `generate-configs` | Smart config generator (kitty → all apps) |
| `install.sh` | Installer with auto-detection |
| `uninstall.sh` | Removal tool (selective or complete) |
| `utils/lock-matugen-mode.sh` | Locks matugen on wallpaper scripts |

## Contributing

Symphony v2.0 is a personal dotfiles project made public. Contributions are welcome!

**What's Coming:**

- Community theme repository
- Plugin system for custom generators
- Better documentation
- Unified rofi menu

**Guidelines:**

- Keep it simple
- Auto-detect everything (no hardcoded lists)
- Test with multiple themes
- Clear documentation

**Submitting Themes:**

- Community themes coming soon
- Share your themes via issues/PRs
- Include: kitty colors, wallpaper, screenshots

---

🎼 Version - 2.0  
🎼 Author - vyrx  
🎼 License - MIT  

---
