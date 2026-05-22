#!/bin/bash

theme=$1
COLOR_FILE="$HOME/.config/eww/_color.scss"
get_color="$HOME/.config/bspwm/bspwm.d/get-color.sh"

# swap active theme
sed -i "s|@import \"themes/.*\"|@import \"themes/${theme}\"|" "$COLOR_FILE"

# wait before continue
sleep 1

# update eww active theme
eww update active-theme="$theme"

# resync sysinfo popup variable
$HOME/.config/eww/scripts/sysinfo-popup-toggle.sh

# apply colors to xcorners and bspwm
killall -9 xcorners
xcorners -y 30 -r 16 -c $($get_color background)FF -1
bspc config normal_border_color \#$($get_color on-surface-dim)
bspc config focused_border_color \#$($get_color accent)

# reload bspwm — handles border colors and xcorners automatically
# bspc wm -r