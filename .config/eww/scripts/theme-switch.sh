#!/bin/bash

theme=$1
COLOR_FILE="$HOME/.config/eww/_color.scss"
get_color="$HOME/.config/bspwm/bspwm.d/get-color.sh"

# update eww
eww update active-theme="$theme"
eww update theme-mode="static"
echo "$theme" > ~/.cache/eww/active-theme
echo "static" > ~/.cache/eww/theme-mode 

# swap active theme
sed -i "s|@import \"themes/.*\"|@import \"themes/${theme}\"|" "$COLOR_FILE"

# swap alacritty to static theme
sed -i "s|themes/.*\.toml|themes/${theme}.toml|" ~/.config/alacritty/alacritty.toml

# wait before continue
sleep 1

# resync sysinfo if open
if eww active-windows | grep -q "sysinfo-popup"; then
  $HOME/.config/eww/scripts/sysinfo-popup-toggle.sh
fi

# apply colors to xcorners and bspwm
killall -9 xcorners
xcorners -y 30 -r 16 -c $($get_color background)FF -1
bspc config normal_border_color \#$($get_color on-surface-dim)
bspc config focused_border_color \#$($get_color accent)