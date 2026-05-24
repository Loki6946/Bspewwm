#!/usr/bin/env bash

set -euo pipefail

WALL_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/eww/thumbs"

# Check for ffmpeg
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is missing!" >&2
  exit 0
fi

mkdir -p "$THUMB_DIR" || exit 1

# Lock to prevent concurrent runs
exec 200>"$THUMB_DIR/.thumb_lock"
flock -n 200 || exit 0

# Clean up stale tmp files from crashed encodes
find "$THUMB_DIR" -maxdepth 1 -name "*.tmp.jpg" -delete

# Build set of valid thumb names and clean orphaned thumbs
declare -A valid_thumbs
while IFS= read -r -d '' wallfile; do
  filename="${wallfile##*/}"
  valid_thumbs["${filename}.jpg"]=1
done < <(find "$WALL_DIR" -maxdepth 1 -type f \
  \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0)

while IFS= read -r -d '' thumb; do
  thumbname="${thumb##*/}"
  if [[ -z "${valid_thumbs[$thumbname]+_}" ]]; then
    rm -f "$thumb"
  fi
done < <(find "$THUMB_DIR" -maxdepth 1 -name "*.jpg" -print0)

# Generate thumbnails in parallel
export THUMB_DIR
find "$WALL_DIR" -maxdepth 1 -type f \
  \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) -print0 | \
  xargs -0 -n 1 -P 4 bash -c '
    set -euo pipefail
    img="$1"
    filename="${img##*/}"
    thumb="$THUMB_DIR/${filename}.jpg"
    tmp_thumb="$THUMB_DIR/${filename}.tmp.jpg"
    if [ ! -f "$thumb" ]; then
      nice -n 19 ionice -c 3 ffmpeg -y -v quiet -threads 1 -i "$img" \
        -vf "scale=440:-1:flags=lanczos" -q:v 3 "$tmp_thumb" \
      && mv "$tmp_thumb" "$thumb" \
      || rm -f "$tmp_thumb"
    fi
  ' _