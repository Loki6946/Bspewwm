#!/bin/bash

wallpaper=$(cat ~/.cache/eww/current-wallpaper 2>/dev/null)

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/wallpaper-preview.jpg"
thumb_dir="$cache_dir/thumbs"
mkdir -p "$cache_dir"

# get wallpaper name without extension
wallpaper_name=$(basename "$wallpaper")

# check if thumb already exists
existing_thumb="$thumb_dir/$(basename "$wallpaper").jpg"

if [[ -f "$existing_thumb" ]]; then
  thumb="$existing_thumb"
else
  if [[ "$(cat $cache_dir/wallpaper-path 2>/dev/null)" != "$wallpaper" ]]; then
    convert "$wallpaper" -resize 250x141^ -gravity center -extent 250x141 "$cache"
    echo "$wallpaper" > "$cache_dir/wallpaper-path"
  fi
  thumb="$cache"
fi

jq -cn \
  --arg thumb "$thumb" \
  --arg name "$wallpaper_name" \
  '{thumb: $thumb, name: $name}'