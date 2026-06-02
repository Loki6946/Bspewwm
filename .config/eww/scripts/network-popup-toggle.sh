#!/bin/bash

LOCKFILE="/tmp/eww-toggle.lock"
if [ -f "$LOCKFILE" ]; then exit 0; fi
touch "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

state=$(eww get network-popup-open)

open_network() {
  bash ~/.config/eww/scripts/close-bar-popups.sh
  if ! eww active-windows | grep -q "network-popup"; then
    eww open network-popup
  fi
  eww update network-popup-open=true
}

close_network() {
  eww close network-popup
  eww update network-popup-open=false
}

case $1 in
  close) close_network; exit 0;;
esac

case $state in
  true) close_network;;
  false) open_network;;
esac
