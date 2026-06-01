#!/bin/bash

PIDFILE="/tmp/screenrecord.pid"
STATEFILE="$HOME/.cache/eww/screen-recording"
SAVE_DIR="$HOME/Videos"
mkdir -p "$SAVE_DIR"

if [[ -f "$PIDFILE" ]]; then
  # stop recording
  pid=$(cat "$PIDFILE")
  kill -INT "$pid" 2>/dev/null
  wait "$pid" 2>/dev/null
  rm -f "$PIDFILE"

  echo "false" > "$STATEFILE"
  eww update screen-recording=false

  filename=$(cat /tmp/screenrecord-filename 2>/dev/null)
  rm -f /tmp/screenrecord-filename

  notify-send -u normal "Screen Recording" "Saved to $(basename $filename)"
else
  # start recording
  filename="$SAVE_DIR/$(date +%Y-%m-%d_%H-%M-%S).mp4"
  echo "$filename" > /tmp/screenrecord-filename

  ffmpeg -f x11grab \
    -r 30 \
    -s 1366x768 \
    -i :0.0 \
    -f pulse -i default \
    -c:v libx264 \
    -preset ultrafast \
    -crf 28 \
    -pix_fmt yuv420p \
    -c:a aac \
    "$filename" &

  echo $! > "$PIDFILE"
  echo "true" > "$STATEFILE"
  eww update screen-recording=true

  notify-send -u low "Screen Recording" "Recording started"
fi