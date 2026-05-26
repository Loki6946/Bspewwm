#!/bin/bash

state=$(eww get volume-popup-open)

open_volume() {
  bash ~/.config/eww/scripts/close-bar-popups.sh

  if ! eww active-windows | grep -q "volume-popup"; then
    eww open volume-popup
  fi
  eww update volume-popup-open=true
}

close_volume() {
  eww close volume-popup
  eww update volume-popup-open=false
}

case $1 in
  close)
    close_volume
    exit 0;;
esac

case $state in
  true)
    close_volume;;
  false)
    open_volume;;
esac