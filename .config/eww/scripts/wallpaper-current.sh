#!/bin/bash

wallpaper=$(cat ~/.cache/eww/current-wallpaper 2>/dev/null)

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/wallpaper-preview.jpg"
thumb_dir="$cache_dir/thumbs"
mkdir -p "$cache_dir"

# check if thumb already exists in thumbs folder
existing_thumb="$thumb_dir/$(basename "$wallpaper").jpg"

if [ -f "$existing_thumb" ]; then
  # use existing thumb — no need to regenerate
  echo "$existing_thumb"
else
  # fallback — generate preview if thumb doesn't exist
  if [ "$(cat $cache_dir/wallpaper-path 2>/dev/null)" != "$wallpaper" ]; then
    convert "$wallpaper" -resize 250x141^ -gravity center -extent 250x141 "$cache"
    echo "$wallpaper" > "$cache_dir/wallpaper-path"
  fi
  echo "$cache"
fi