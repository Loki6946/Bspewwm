#!/bin/bash

PIDFILE="/tmp/color-picker-timer.pid"

if [ -f "$PIDFILE" ]; then
  kill $(cat "$PIDFILE") 2>/dev/null
  rm "$PIDFILE"
fi

eww update color-picker-popup-open=false
eww close color-picker-popup