#!/bin/bash

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