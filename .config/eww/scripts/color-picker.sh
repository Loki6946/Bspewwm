#!/bin/bash

PIDFILE="/tmp/color-picker-timer.pid"

# kill previous timer if running
if [ -f "$PIDFILE" ]; then
  kill $(cat "$PIDFILE") 2>/dev/null
  rm "$PIDFILE"
fi

# pick color and copy to clipboard
color=$(gpick -p -s -o)

if [ -z "$color" ]; then
  exit 0
fi

echo -n "$color" | xclip -selection clipboard

# update eww
eww update color-picker-value="$color"
eww update color-picker-popup-open=true
eww open color-picker-popup

# auto close with PID tracking
(sleep 8 && eww update color-picker-popup-open=false && eww close color-picker-popup) &
echo $! > "$PIDFILE"