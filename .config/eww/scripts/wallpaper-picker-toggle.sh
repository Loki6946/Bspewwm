#!/bin/bash

LOCKFILE="/tmp/eww-toggle.lock"
if [ -f "$LOCKFILE" ]; then exit 0; fi
touch "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

state=$(eww get wallpaper-picker-open)

open_wallpaper() {
  if eww active-windows | grep -q "sysinfo-popup"; then
    eww close sysinfo-popup
    eww update sysinfo-popup-open=false
  fi
  
  if ! eww active-windows | grep -q "wallpaper-picker"; then
    eww open wallpaper-picker
  fi
  eww update wallpaper-picker-open=true
}

close_wallpaper() {
  eww close wallpaper-picker
  eww update wallpaper-picker-open=false
}

case $1 in
  close) close_wallpaper; exit 0;;
esac

case $state in
  true) close_wallpaper;;
  false) open_wallpaper;;
esac