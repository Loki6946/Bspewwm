#!/bin/bash

LOCKFILE="/tmp/eww-toggle.lock"
if [ -f "$LOCKFILE" ]; then exit 0; fi
touch "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

state=$(eww get calendar-popup-open)

open_calendar() {
  bash ~/.config/eww/scripts/close-bar-popups.sh
  if ! eww active-windows | grep -q "calendar-popup"; then
    eww open calendar-popup
  fi
  eww update calendar-popup-open=true
}

close_calendar() {
  eww close calendar-popup
  eww update calendar-popup-open=false
}

case $1 in
  close) close_calendar; exit 0;;
esac

case $state in
  true) close_calendar;;
  false) open_calendar;;
esac