#!/bin/bash

# THUMB_DIR="$HOME/.cache/eww/thumbs"
# WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# mkdir -p "$THUMB_DIR"

# # clean orphaned thumbs first
# for thumb in "$THUMB_DIR"/*.jpg; do
#   [ -f "$thumb" ] || continue  # skip if no thumbs exist yet
#   basename=$(basename "$thumb" .jpg)
#   if [ ! -f "$WALLPAPER_DIR/$basename" ]; then
#     rm "$thumb"
#   fi
# done

# # generate missing thumbs
# for img in "$WALLPAPER_DIR"/*; do
#   ext="${img##*.}"
#   if [[ "$ext" =~ ^(jpg|jpeg|png|JPG|JPEG|PNG)$ ]]; then
#     thumb="$THUMB_DIR/$(basename "$img").jpg"
#     # regenerate if thumb exists at old size
#     convert "$img" -resize 240x135^ -gravity center -extent 240x135 -quality 85 "$thumb" 2>/dev/null
#   fi
# done

#!/bin/bash

LOCK="/tmp/wallpaper-thumbs.lock"

# prevent multiple instances
if [ -f "$LOCK" ]; then
  exit 0
fi
touch "$LOCK"

THUMB_DIR="$HOME/.cache/eww/thumbs"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

mkdir -p "$THUMB_DIR"

# clean orphaned thumbs
for thumb in "$THUMB_DIR"/*.jpg; do
  [ -f "$thumb" ] || continue
  basename=$(basename "$thumb" .jpg)
  if [ ! -f "$WALLPAPER_DIR/$basename" ]; then
    rm "$thumb"
  fi
done

# generate missing thumbs
for img in "$WALLPAPER_DIR"/*; do
  ext="${img##*.}"
  if [[ "$ext" =~ ^(jpg|jpeg|png|JPG|JPEG|PNG)$ ]]; then
    thumb="$THUMB_DIR/$(basename "$img").jpg"
    if [ ! -f "$thumb" ]; then
      convert "$img" -resize 240x135^ -gravity center -extent 240x135 -quality 85 "$thumb" 2>/dev/null
    fi
  fi
done

rm "$LOCK"