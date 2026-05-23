#!/bin/bash

# kill duplicate listener processes
pkill -f "playerctl metadata -F" 2>/dev/null
pkill -f "nmcli monitor" 2>/dev/null
pkill -f "inotifywait.*Wallpapers" 2>/dev/null
pkill -f "scripts/music.sh" 2>/dev/null
pkill -f "scripts/network.sh" 2>/dev/null
pkill -f "scripts/volume.sh" 2>/dev/null
pkill -f "scripts/get-keyboard-layout.sh" 2>/dev/null
pkill -f "wallpaper-thumbs-generate.sh" 2>/dev/null

# wait for processes to die
sleep 0.3

for pidfile in /tmp/color-picker-timer.pid \
               /tmp/network-notif-timer.pid \
               /tmp/power-pending-timer.pid; do
  if [ -f "$pidfile" ]; then
    kill $(cat "$pidfile") 2>/dev/null
    rm "$pidfile"
  fi
done

# reset states
eww update color-picker-popup-open=false
eww update network-notif-open=false
eww update power-pending-name=""
eww update power-pending-action=""

# restore theme mode
if [ -f ~/.cache/eww/theme-mode ]; then
  eww update theme-mode=$(cat ~/.cache/eww/theme-mode)
else
  eww update theme-mode="static"
fi

# restore dynamic type
if [ -f ~/.cache/eww/dynamic-type ]; then
  eww update dynamic-type=$(cat ~/.cache/eww/dynamic-type)
else
  eww update dynamic-type="tonal-spot"
fi

# restore active theme
if [ -f ~/.cache/eww/active-theme ]; then
  eww update active-theme=$(cat ~/.cache/eww/active-theme)
else
  eww update active-theme="blue"
fi