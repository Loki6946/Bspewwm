#!/bin/bash

LOCKFILE="/tmp/eww-toggle.lock"
if [ -f "$LOCKFILE" ]; then exit 0; fi
touch "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

state=$(eww get music-popup-open)

open_music() {
  if ! eww active-windows | grep -q "music-popup"; then
    eww open music-popup
  fi
  eww update music-popup-open=true
}

close_music() {
  eww close music-popup
  eww update music-popup-open=false
}

case $1 in
  close) close_music; exit 0;;
esac

case $state in
  true) close_music;;
  false) open_music;;
esac