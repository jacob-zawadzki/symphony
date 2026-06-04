-- ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗    ██████╗ ██╗   ██╗██╗     ███████╗███████╗
-- ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║    ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
-- ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║    ██████╔╝██║   ██║██║     █████╗  ███████╗
-- ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║    ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
-- ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝    ██║  ██║╚██████╔╝███████╗███████╗███████║
--  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
-- https://wiki.hyprland.org/Configuring/Window-Rules/
-- Hyprland 0.55+ syntax

-- =============================================================================
-- General
-- =============================================================================

-- Fix some dragging issues with XWayland
hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = false,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Force Polkit Auth to open on active workspace
hl.window_rule({
	match = {
		class = "polkit-gnome-authentication-agent-1",
	},
	workspace = "unset",
})

-- Prevent apps from auto-maximizing themselves
hl.window_rule({
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

-- 97% opacity when focused, 90% when unfocused
hl.window_rule({
	match = {
		class = ".*",
	},
	opacity = "0.97 0.9",
})

hl.layer_rule({
	match = {
		namespace = "selection",
	},
	no_anim = true,
})

-- =============================================================================
-- Floating Windows
-- =============================================================================

-- Apply float/center/size to anything tagged as a floating window
hl.window_rule({
	match = {
		tag = "floating-window",
	},
	float = true,
	center = true,
	size = "800 600",
})

-- Tag floating apps by class
hl.window_rule({
	match = {
		class = "(blueman-manager|xdg-desktop-portal-gtk|localsend|Wiremix|nmgui)",
	},
	tag = "+floating-window",
	workspace = "unset",
})

-- Tag floating apps by title
hl.window_rule({
	match = {
		title = "^(.*Network Manager.*)$",
	},
	tag = "+floating-window",
})
hl.window_rule({
	match = {
		title = "(webapp-install|share)",
	},
	tag = "+floating-window",
})

-- Symphony TUI
hl.window_rule({
	match = {
		title = "symphony-tui",
	},
	float = true,
	center = true,
	size = "720 580",
})

-- Symphony Browse (larger for preview)
hl.window_rule({
	match = {
		title = "symphony-browse",
	},
	float = true,
	center = true,
	size = "1200 750",
})

-- Easyeffects (music equalizer)
hl.window_rule({
	match = {
		class = "com.github.wmmm.easyeffects",
	},
	float = true,
	center = true,
	size = "950 850",
})

-- =============================================================================
-- Steam
-- =============================================================================

hl.window_rule({
	match = {
		class = "steam",
		title = "Steam",
	},
	float = true,
	center = true,
	size = "1100 700",
	opacity = "1 override 1 override",
	idle_inhibit = "fullscreen",
})

hl.window_rule({
	match = {
		class = "steam",
		title = "Friends List",
	},
  float = true,
  center = true,
  opacity = "1 override 1 override",
	size = "460 800",
})

hl.window_rule({
	match = {
		class = "steam",
		title = "Steam Settings",
	},
  float = true,
  center = true,
  opacity = "1 override 1 override",
	size = "1063 798",
})

-- =============================================================================
-- Miscellaneous
-- =============================================================================

-- Screensaver
hl.window_rule({
	match = {
		class = "Screensaver",
	},
	fullscreen = true,
	float = true,
	center = true,
})

-- Hide Bitwarden from screen share
hl.window_rule({
	match = {
		class = "^(Bitwarden)$",
	},
	no_screen_share = true,
})

-- feh (image viewer)
hl.window_rule({
	match = {
		class = "feh",
	},
	float = true,
	center = true,
	size = "1280 720",
	opacity = "1 override 1 override",
})

-- mpv (video player)
hl.window_rule({
	match = {
		class = "mpv",
	},
	float = true,
	center = true,
	size = "1280 720",
	opacity = "1 override 1 override",
})

-- =============================================================================
-- Browsers
-- =============================================================================

-- Tag browser types.
-- brave.* catches brave-browser and all webapps (brave-youtube.com__-Default etc.)
hl.window_rule({
	match = {
		class = "((google-)?[cC]hrom(e|ium)|brave.*|[mM]icrosoft-edge|Vivaldi-stable|helium)",
	},
	tag = "+chromium-based-browser",
})
hl.window_rule({
	match = {
		class = "([fF]irefox|zen|librewolf)",
	},
	tag = "+firefox-based-browser",
})

-- Force chromium-based browsers into a tile to deal with --app bug
hl.window_rule({
	match = {
		tag = "chromium-based-browser",
	},
	tile = true,
})

-- Browsers are fully opaque when focused, inherit global when unfocused
hl.window_rule({
	match = {
		tag = "chromium-based-browser",
	},
	opacity = "1 override 0.97",
})
hl.window_rule({
	match = {
		tag = "firefox-based-browser",
	},
	opacity = "1 override 0.97",
})

-- Video sites as webapps
hl.window_rule({
	match = {
		class = "brave-(youtube|reddit|twitch|kick).*",
	},
	opacity = "1 override 1 override",
})

-- Video sites in a regular Brave tab
hl.window_rule({
	match = {
		title = "(?i).*(youtube|reddit|twitch|kick).*- Brave$",
	},
	opacity = "1 override 1 override",
})

-- =============================================================================
-- Picture-in-Picture
-- =============================================================================

hl.window_rule({
	match = {
		title = "(Picture.?in.?[Pp]icture)",
	},
	tag = "+pip",
})
hl.window_rule({
	match = {
		tag = "pip",
	},
	float = true,
	pin = true,
	size = "600 338",
	keep_aspect_ratio = true,
	border_size = 0,
	opacity = "1 override 1 override",
})

-- =============================================================================
-- Special Workspaces
-- =============================================================================

hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "kitty --title scratchpad" })
hl.window_rule({
	match = { title = "scratchpad" },
	float = true,
	center = true,
	size = "850 600",
})

hl.workspace_rule({ workspace = "special:sysmon", on_created_empty = "kitty --title sysmon -e btop" })
hl.window_rule({
	match = { title = "sysmon" },
	float = true,
	center = true,
	size = "850 600",
})

hl.workspace_rule({ workspace = "special:quickfiles", on_created_empty = "kitty --title quickfiles -e yazi" })
hl.window_rule({
	match = { title = "quickfiles" },
	float = true,
	center = true,
	size = "850 600",
})

hl.workspace_rule({ workspace = "special:quickmusic", on_created_empty = "kitty --title quickmusic -e rmpc" })
hl.window_rule({
	match = { title = "quickmusic" },
	float = true,
	center = true,
	size = "850 600",
})

hl.workspace_rule({ workspace = "special:wifi", on_created_empty = "kitty --title wlctl -e wlctl" })
hl.window_rule({
	match = { title = "wlctl" },
	float = true,
	center = true,
	size = "870 550",
})

hl.workspace_rule({ workspace = "special:bluetooth", on_created_empty = "kitty --title bluetooth -e bluetui" })
hl.window_rule({
	match = { title = "bluetooth" },
	float = true,
	center = true,
	size = "870 550",
})
