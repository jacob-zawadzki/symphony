<pre>
        ♪                                            ♫
   ▄▄▄▄▄                                         ♪
  ██▀▀▀▀█▄                      █▄           ♬
  ▀██▄  ▄▀       ▄              ██          ▄
    ▀██▄▄  ██ ██ ███▄███▄ ████▄ ████▄ ▄███▄ ████▄ ██ ██
  ▄   ▀██▄ ██▄██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██▄██
  ▀██████▀▄▄▀██▀▄██ ██ ▀█▄████▀▄██ ██▄▀███▀▄██ ▀█▄▄▀██▀
     ♫       ██           ██                        ██
           ▀▀▀     ♪      ▀              ♬        ▀▀▀
</pre>

I love music and musical films (La La Land, Your Lie in April), and I listen to a lot of jazz/instrumentals. That’s where the name and the setup idea come from. You’ll see the music touch more and more over time.

> ⚠️ Warning: Read the scripts before running. This switches configs and reloads apps. You are responsible for what you run.

## Installation

> ⚠️ Read first: this switches configs and reloads apps. You are responsible for what you run.

```bash
git clone https://github.com/vyrx-dev/dotfiles.git ~/dotfiles
cd ~/dotfiles/theme-scripts
./install.sh
```

Uninstall:
```bash
./uninstall.sh
```

## Themes

- dynamic
- espresso 
- forest
- gruvbox-material
- kanagawa
- nordic
- rose-pine
- sakura
- tokyo-night
- void
- zen

Wallpapers: [vyrx-dev/wallpapers](https://github.com/vyrx-dev/wallpapers)

## Usage

```bash
symphony switch          # pick a theme
symphony switch zen      # switch directly
symphony list            # see all themes
symphony reload          # re-apply current
symphony fix             # fix broken symlinks
```

## Keybindings

| Shortcut | Action |
|----------|--------|
| `Super + Ctrl + Shift + Space` | Theme switcher |
| `Super + Ctrl + Space` | Matugen (colors from wallpaper) |
| `Super + Alt + Space` | Wallpaper picker |
| `Super + Alt + Left/Right` | Cycle wallpapers |
| `Super + Backspace` | Toggle terminal transparency |
| `Super + Ctrl + Backspace` | Toggle focus/vibe mode |

## How it works

Symphony updates `~/.config/symphony/current` and runs hooks to reload apps. No files are overwritten.

## Hooks (what it covers)

- Terminals: kitty, ghostty, alacritty
- UI: Hyprland, Waybar, GTK3/4, Rofi
- Utilities: btop, cava
- Apps: yazi, rmpc, vesktop, obsidian
- Extras: pywalfox, Neovim

## Adding your own theme

Copy an existing theme:
```bash
cp -r themes/zen themes/my-theme
```
Edit configs in `themes/my-theme/.config/` and add wallpapers to `themes/my-theme/backgrounds/`.

## Dependencies

- Required: `stow`, `hyprctl`, `swww`
- Terminal (one of): `kitty`, `ghostty`, `alacritty`
- Optional: `waybar`, `rofi`, `gum`, `tte`, `matugen`

## Troubleshooting

```bash
symphony reload    # colors not updating
symphony fix       # symlinks broken
```

---

Thanks / Inspirations:
- [basecamp/omarchy](https://github.com/basecamp/omarchy)
- [HyDE-Project/HyDE](https://github.com/HyDE-Project/HyDE)
- [JaKooLit/Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots)
- [mylinuxforwork/dotfiles](https://github.com/mylinuxforwork/dotfiles)
- [bjarneo/omarchy-sakura-theme](https://github.com/bjarneo/omarchy-sakura-theme)
- [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- [sainnhe/gruvbox-material](https://github.com/sainnhe/gruvbox-material)
- [EliverLara/Nordic](https://github.com/EliverLara/Nordic)
- [rose-pine/rose-pine-theme](https://github.com/rose-pine/rose-pine-theme)
- [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [InioX/matugen](https://github.com/InioX/matugen)

Have an idea or found a bug?
- Report a bug: [new bug](https://github.com/vyrx-dev/dotfiles/issues/new?template=bug_report.yml)
- Request a feature: [new feature](https://github.com/vyrx-dev/dotfiles/issues/new?template=feature_request.yml)
