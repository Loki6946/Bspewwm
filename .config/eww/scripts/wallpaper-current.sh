#!/bin/bash

wallpaper=$(awk '/\[xin_-1\]/{found=1} found && /^file=/{print substr($0,6); exit}' ~/.config/nitrogen/bg-saved.cfg)

cache_dir="$HOME/.cache/eww"
cache="$cache_dir/wallpaper-preview.jpg"
mkdir -p "$cache_dir"

# only resize if wallpaper changed
if [ "$(cat $cache_dir/wallpaper-path 2>/dev/null)" != "$wallpaper" ]; then
  convert "$wallpaper" -resize 250x141^ -gravity center -extent 250x141 "$cache"
  echo "$wallpaper" > "$cache_dir/wallpaper-path"
fi

echo "$cache"