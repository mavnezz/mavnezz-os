# Hyprland Keybindings — Black Don OS

## 🗝️ Conventions
- SUPERKEY = Mod key (Hyprland `$modifier`)
- SHIFT, CTRL, ALT used as shown
- Arrows and hjkl are both supported for movement

---

## 🚀 Applications
- SUPERKEY+T — Launch default terminal (${terminal})
- SUPERKEY+B — Launch browser (${browser})
- SUPERKEY+Y — Kitty running Yazi (file manager)
- SUPERKEY+F — Thunar (file manager)
- SUPERKEY+M — Pavucontrol (audio)
- SUPERKEY+G — Telegram Desktop
- SUPERKEY+D — Discord
- SUPERKEY+S — Steam
- SUPERKEY+SHIFT+O — OBS Studio (flatpak)
- SUPERKEY+SHIFT+Z — Zed Editor
- SUPERKEY+SHIFT+E — Emoji picker (emopicker9000)
- SUPERKEY+SPACE — Vicinae launcher
- SUPERKEY+SHIFT+W — Web search
- SUPERKEY+ALT+W — Wallsetter
- SUPERKEY+C — Hyprpicker (color picker)
- SUPERKEY+L — Hyprlock (screen lock)
- SUPERKEY+X — Wlogout (logout menu)
- SUPERKEY+K — List keybinds
- SUPERKEY+Z — Pypr zoom
- SUPERKEY+SHIFT+T — Pypr toggle term
- SUPERKEY+SHIFT+CTRL+D — nwg-displays
- SUPERKEY+ALT+M — Moonlight (AppImage)

## 📸 Screenshots
- SUPERKEY+SHIFT+S — screenshootin

## 🪟 Window Management
- SUPERKEY+Q — Kill active window
- SUPERKEY+P — Pseudo tile
- SUPERKEY+SHIFT+I — Toggle split
- SUPERKEY+SHIFT+F — Fullscreen
- SUPERKEY+W — Toggle floating
- SUPERKEY+SHIFT+CTRL+W — Workspace option: allfloat

### Move Window
- SUPERKEY+SHIFT+Left/Right/Up/Down — Move window L/R/U/D
- SUPERKEY+SHIFT+H/J/K/L — Move window L/D/U/R

### Swap Window
- SUPERKEY+ALT+Left/Right/Up/Down — Swap window L/R/U/D
- SUPERKEY+ALT+[, . , - , ,] — Swap window L/R/U/D (keycodes 43,46,45,44)

### Focus Movement
- SUPERKEY+Left/Right/Up/Down — Focus L/R/U/D

### Workspace Navigation
- SUPERKEY+1..9,0 — Go to workspace 1..10
- SUPERKEY+SHIFT+1..9,0 — Move window to workspace 1..10
- SUPERKEY+CTRL+Right/Left — Next/Previous workspace (relative)
- SUPERKEY+CTRL+ALT+Right/Left — Move to workspace relative +1/-1
- SUPERKEY+Mouse Wheel Down/Up — Workspace r+1/r-1

### Alt-Tab
- ALT+Tab — Cycle next
- ALT+Tab — Bring active to top (runs twice to ensure raise)

## 🔊 Media & Brightness
- XF86AudioRaiseVolume — wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
- XF86AudioLowerVolume — wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
- XF86AudioMute — wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
- XF86AudioPlay/Pause — playerctl play-pause
- XF86AudioNext/Prev — playerctl next/previous
- XF86MonBrightnessDown/Up — brightnessctl set 5%-/+5%

## 🖱️ Mouse Bindings
- SUPERKEY + Left Mouse — Move window
- SUPERKEY + Right Mouse — Resize window

