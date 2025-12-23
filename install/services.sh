#!/bin/bash
#|---/ /+---------------------+---/ /|#
#|--/ /-| Symphony Dotfiles   |--/ /-|#
#|-/ /--| User Services       |-/ /--|#
#|/ /---+---------------------+/ /---|#

step "Setting up services"

if pkg_installed mpd; then
    mkdir -p ~/.config/systemd/user/mpd.service.d
    echo -e "[Service]\nRuntimeDirectory=mpd" > ~/.config/systemd/user/mpd.service.d/override.conf
    systemctl --user daemon-reload
    systemctl --user enable --now mpd && ok "mpd" || warn "mpd failed"
fi
