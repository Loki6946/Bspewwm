#!/bin/bash

type=${1:-tonal-spot}
wallpaper=$(cat ~/.cache/eww/current-wallpaper 2>/dev/null)
COLOR_FILE="$HOME/.config/eww/_color.scss"
get_color="$HOME/.config/bspwm/bspwm.d/get-color.sh"

# save state
echo "dynamic" > ~/.cache/eww/theme-mode
echo "dynamic" > ~/.cache/eww/active-theme
echo "$type" > ~/.cache/eww/dynamic-type

# update eww
eww update theme-mode="dynamic"
eww update active-theme="dynamic"
eww update dynamic-type="$type"

# generate with selected type
matugen image "$wallpaper" --source-color-index 0 --type "scheme-$type"

# swap to dynamic theme
sed -i "s|@import \"themes/.*\"|@import \"themes/dynamic\"|" "$COLOR_FILE"

# swap alacritty to dynamic theme
sed -i "s|themes/.*\.toml|themes/dynamic.toml|" ~/.config/alacritty/alacritty.toml

sleep 1

# resync sysinfo if open
if eww active-windows | grep -q "sysinfo-popup"; then
  $HOME/.config/eww/scripts/sysinfo-popup-toggle.sh
fi

# apply colors
killall -9 xcorners
xcorners -y 30 -r 16 -c $($get_color background)FF -1
bspc config normal_border_color \#$($get_color on-surface-dim)
bspc config focused_border_color \#$($get_color accent)