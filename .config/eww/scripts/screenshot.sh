#!/bin/bash

action=$1
delay=$(eww get screenshot-delay)
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
filename="$SAVE_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

case $action in
  full)
    maim -d "$delay" "$filename"
    ;;
  selection)
    maim -b 2 -c 225,0,0 -d "$delay" -s "$filename"
    ;;
esac

# check if screenshot was actually taken
if [[ ! -f "$filename" ]]; then
  notify-send -u low "Screenshot" "Cancelled"
  exit 0
fi

# check if file is empty
if [[ ! -s "$filename" ]]; then
  rm -f "$filename"
  notify-send -u low "Screenshot" "Cancelled"
  exit 0
fi

# copy to clipboard
xclip -selection clipboard -t image/png < "$filename"

# notify
notify-send "Screenshot" "$(basename $filename) saved"