#!/bin/bash
# Symphony Installer - sets up the theme system
# https://github.com/vyrx-dev/dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"
THEMES_DIR="$DOTFILES/themes"
SYMPHONY_DIR="$HOME/.config/symphony"
LOGO="$DOTFILES/branding/screensaver.txt"

# center output based on terminal width
WIDTH=$(stty size 2>/dev/null </dev/tty | cut -d' ' -f2 || echo 80)
[[ -f "$LOGO" ]] && LOGO_W=$(awk '{if(length>m)m=length}END{print m+0}' "$LOGO") || LOGO_W=50
PAD=$(printf "%*s" $(( (WIDTH - LOGO_W) / 2 )) "")

purple="\033[38;5;183m"
lavender="\033[38;5;147m"
green="\033[38;5;114m"
dim="\033[38;5;240m"
red="\033[38;5;203m"
reset="\033[0m"

has_gum=$(command -v gum &>/dev/null && echo 1 || echo 0)
has_tte=$(command -v tte &>/dev/null && echo 1 || echo 0)

title() { [[ $has_gum -eq 1 ]] && gum style --foreground 183 --italic "$1" || echo -e "${purple}${PAD}$1${reset}"; }
ok()    { echo -e "${green}${PAD}  ✓ ${reset}$1"; }
fail()  { echo -e "${red}${PAD}  ✗ ${reset}$1"; }
info()  { echo -e "${dim}${PAD}  ♪ ${reset}$1"; }

spin() {
    local msg="$1"; shift
    if [[ $has_gum -eq 1 ]]; then
        gum spin --spinner dot --spinner.foreground="183" --title="  $msg" -- "$@" 2>/dev/null
    else
        info "$msg"; "$@" >/dev/null 2>&1
    fi
}

show_logo() {
    clear
    [[ ! -f "$LOGO" ]] && return
    if [[ $has_tte -eq 1 ]]; then
        tte -i "$LOGO" --canvas-width 0 --anchor-text c --frame-rate 120 decrypt \
            --typing-speed 2 --ciphertext-colors 8e7cc3 b4a7d6 d9d2e9 \
            --final-gradient-stops 9c89b8 f0a6ca efc3e6 \
            --final-gradient-direction vertical 2>/dev/null || cat "$LOGO"
    else
        while IFS= read -r line; do echo -e "${lavender}${PAD}${line}${reset}"; done < "$LOGO"
    fi
    echo
}

check_deps() {
    title "First Movement ~ Gathering the Orchestra"
    echo
    local missing=()
    for cmd in stow hyprctl swww; do
        command -v "$cmd" &>/dev/null && ok "$cmd" || { fail "$cmd"; missing+=("$cmd"); }
    done
    [[ ${#missing[@]} -gt 0 ]] && { fail "Missing: ${missing[*]}"; exit 1; }
    echo
}

setup() {
    title "Second Movement ~ Preparing the Stage"
    echo
    spin "Creating directories" bash -c "mkdir -p '$SYMPHONY_DIR' '$HOME/.config/rmpc/themes' '$HOME/.cache/wal'"
    ok "Directories ready"
    spin "Setting permissions" bash -c "chmod +x '$SCRIPT_DIR'/symphony '$SCRIPT_DIR'/hooks/*.sh 2>/dev/null || true"
    ok "Scripts ready"
    echo
}

setup_path() {
    title "Third Movement ~ Finding Your Voice"
    echo
    local rc="" shell=""
    [[ -f "$HOME/.config/fish/config.fish" ]] && rc="$HOME/.config/fish/config.fish" shell="fish"
    [[ -z "$rc" && -f "$HOME/.zshrc" ]] && rc="$HOME/.zshrc" shell="zsh"
    [[ -z "$rc" && -f "$HOME/.bashrc" ]] && rc="$HOME/.bashrc" shell="bash"

    if [[ -n "$rc" ]] && ! grep -q "symphony" "$rc" 2>/dev/null; then
        echo -e "\n# Symphony" >> "$rc"
        [[ "$shell" == "fish" ]] && echo "set -gx PATH $SCRIPT_DIR \$PATH" >> "$rc" \
                                 || echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >> "$rc"
        ok "Added to $shell"
    else
        ok "Path already set"
    fi
    echo
}

select_theme() {
    title "Fourth Movement ~ Choosing Your Melody"
    echo
    themes=()
    for d in "$THEMES_DIR"/*/; do
        [[ -d "$d" ]] || continue
        name=$(basename "$d")
        [[ "$name" != "Wallpapers" && "$name" != ".git" ]] && themes+=("$name")
    done
    [[ ${#themes[@]} -eq 0 ]] && { fail "No themes found"; exit 1; }
    info "Found ${#themes[@]} themes"
    echo

    if [[ $has_gum -eq 1 ]]; then
        THEME=$(printf '%s\n' "${themes[@]}" | gum choose --header="Pick a theme:" --height=12)
    else
        for t in "${themes[@]}"; do echo -e "${PAD}    $t"; done
        read -rp "${PAD}  Choose: " THEME
    fi
    [[ -z "$THEME" ]] && THEME="${themes[0]}"
    echo "$THEME" > "$SYMPHONY_DIR/.current-theme"
    ok "Selected: $THEME"
    echo
}

apply_theme() {
    title "Fifth Movement ~ The Performance Begins"
    echo
    spin "Applying $THEME" bash -c "'$SCRIPT_DIR/symphony' switch '$THEME' >/dev/null 2>&1"
    ok "Theme applied"
    echo
}

finale() {
    clear
    if [[ $has_tte -eq 1 && -f "$LOGO" ]]; then
        tte -i "$LOGO" --canvas-width 0 --anchor-text c --frame-rate 60 beams \
            --beam-delay 1 --beam-row-symbols ♪ ♫ ♬ ♩ \
            --final-gradient-stops 9c89b8 f0a6ca b8e0d2 \
            --final-gradient-direction radial 2>/dev/null || cat "$LOGO"
    elif [[ -f "$LOGO" ]]; then
        while IFS= read -r line; do echo -e "${lavender}${PAD}${line}${reset}"; done < "$LOGO"
    fi
    echo
    echo -e "${green}${PAD}~ The Symphony is Ready ~${reset}"
    echo
    echo -e "${dim}${PAD}  Theme: ${lavender}$THEME${reset}"
    echo -e "${dim}${PAD}  Available: ${lavender}${#themes[@]}${reset}"
    echo
    echo -e "${dim}${PAD}  Commands:${reset}"
    echo -e "${purple}${PAD}    symphony switch${dim}  - change theme${reset}"
    echo -e "${purple}${PAD}    symphony list${dim}    - view themes${reset}"
    echo
    echo -e "${dim}${PAD}  Keybindings:${reset}"
    echo -e "${purple}${PAD}    Super+Ctrl+T${dim}     - theme picker${reset}"
    echo -e "${purple}${PAD}    Super+Alt+W${dim}      - wallpaper picker${reset}"
    echo
    echo -e "${lavender}${PAD}  ♪ Let the music play ♪${reset}"
    echo
}

main() {
    # optional tools (no auto-install)
    if [[ $has_gum -eq 0 || $has_tte -eq 0 ]]; then
        title "Optional Tools"
        [[ $has_gum -eq 0 ]] && info "gum not found — fancy UI disabled"
        [[ $has_tte -eq 0 ]] && info "tte not found — static ASCII used"
        echo
    fi

    show_logo
    sleep 0.3
    title "~ Symphony Installation ~"
    echo -e "${dim}${PAD}  A theme system that flows like music${reset}"
    echo
    sleep 0.2

    check_deps
    setup
    setup_path
    select_theme
    apply_theme
    finale
}

main
