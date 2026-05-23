#!/bin/bash
wallpaper=$1
feh --bg-scale "$wallpaper"
echo "$wallpaper" > ~/.cache/eww/current-wallpaper

# if adaptive mode regenerate theme
if [ "$(eww get theme-mode)" = "dynamic" ]; then
  ~/.config/eww/scripts/theme-dynamic.sh
fi