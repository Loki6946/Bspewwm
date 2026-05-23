#!/bin/bash

action="$1"
name="$2"
PIDFILE="/tmp/power-pending-timer.pid"

current_pending=$(eww get power-pending-name)

if [ "$current_pending" = "$name" ]; then
  # second click — execute
  if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE") 2>/dev/null
    rm "$PIDFILE"
  fi

  eww update power-pending-action=""
  eww update power-pending-name=""
  eww update power-popup-open=false
  eww close power-bg
  eww close power-popup

  sleep 0.2 # wait for animation
  $action
else
  # first click — set pending, kill previous timer if switching buttons
  if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE") 2>/dev/null
    rm "$PIDFILE"
  fi

  eww update power-pending-action="$action"
  eww update power-pending-name="$name"

  # reset after 3 seconds
  (sleep 3 && eww update power-pending-name="" && eww update power-pending-action="") &
  echo $! > "$PIDFILE"
fi