#!/bin/bash
PIDFILE="/tmp/network-notif-timer.pid"

if [ -f "$PIDFILE" ]; then
  kill $(cat "$PIDFILE") 2>/dev/null
  rm "$PIDFILE"
fi

eww update network-notif-open=false
eww close network-notif