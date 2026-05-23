#!/bin/bash

# PIDFILE="/tmp/power-pending-timer.pid"
# state=$(eww get power-popup-open)

# open_power() {
#   if ! eww active-windows | grep -q "power-popup"; then
#     eww open power-popup
#   fi
#   eww update power-popup-open=true
# }

# close_power() {
#   # kill pending timer and reset
#   if [ -f "$PIDFILE" ]; then
#     kill $(cat "$PIDFILE") 2>/dev/null
#     rm "$PIDFILE"
#   fi
#   eww update power-pending-name=""
#   eww update power-pending-action=""
#   eww update power-popup-open=false
#   eww close power-popup
# }

# case $1 in
#   close)
#     close_power
#     exit 0;;
# esac

# case $state in
#   true) close_power;;
#   false) open_power;;
# esac

PIDFILE="/tmp/power-pending-timer.pid"
state=$(eww get power-popup-open)

open_power() {
  eww open power-bg
  eww open power-popup
  eww update power-popup-open=true
}

close_power() {
  if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE") 2>/dev/null
    rm "$PIDFILE"
  fi
  eww update power-pending-name=""
  eww update power-pending-action=""
  eww update power-popup-open=false
  eww close power-popup
  eww close power-bg
}

case $1 in
  close) close_power; exit 0;;
esac

case $state in
  true) close_power;;
  false) open_power;;
esac