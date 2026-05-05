#!/bin/bash

state=$(eww get screenshot-popup-open)

open_screenshot() {
  if ! eww active-windows | grep -q "screenshot-popup"; then
    eww open screenshot-popup
  fi
  eww update screenshot-popup-open=true
}

close_screenshot() {
  eww close screenshot-popup
  eww update screenshot-popup-open=false
}

case $1 in
  close)
    close_screenshot
    exit 0;;
esac

case $state in
  true)
    close_screenshot;;
  false)
    open_screenshot;;
esac