#!/bin/bash

no_error() {
    pkill volume-check.sh
    ~/.config/eww/scripts/volume-check.sh &
}

error() {
    ~/.config/eww/scripts/volume-check.sh &
}

no_error || error

# requieres pamixer

case $1 in
--up)
  pamixer -u >/dev/null
  pamixer -i 5 >/dev/null
  ;;
--down)
  pamixer -u >/dev/null
  pamixer -d 5 >/dev/null
  ;;
--toggle)
  pamixer -t >/dev/null
  ;;
esac