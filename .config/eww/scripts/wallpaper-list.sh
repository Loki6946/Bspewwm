#!/bin/bash

THUMB_DIR="$HOME/.cache/eww/thumbs"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | sort | while read -r img; do
  thumb="$THUMB_DIR/$(basename "$img").jpg"
  if [ -f "$thumb" ]; then
    jq -n --arg path "$img" --arg thumb "$thumb" '{path: $path, thumb: $thumb}'
  fi
done | jq -s '[_nwise(.; 3)]'