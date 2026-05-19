#!/bin/bash

theme=$1
COLOR_FILE="$HOME/.config/eww/_color.scss"

# swap active theme
sed -i "s|@import \"themes/.*\"|@import \"themes/${theme}\"|" "$COLOR_FILE"

# wait before continue
sleep 1.5

# update eww active theme
eww update active-theme="$theme"

# Resync sysinfo popup
$HOME/.config/eww/scripts/sysinfo-popup-toggle.sh

# reload bspwm — handles border colors and xcorners automatically
bspc wm -r