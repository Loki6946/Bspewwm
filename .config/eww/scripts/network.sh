#!/bin/bash

PIDFILE="/tmp/network-notif-timer.pid"
STATEFILE="/tmp/network-state.tmp"

show_notif() {
  local message="$1"
  local icon="$2"

  # kill previous timer
  if [ -f "$PIDFILE" ]; then
    kill $(cat "$PIDFILE") 2>/dev/null
    rm "$PIDFILE"
  fi

  eww update network-notif-message="$message"
  eww update network-notif-icon="$icon"
  eww update network-notif-open=true
  eww open network-notif

  (sleep 5 && eww update network-notif-open=false && eww close network-notif) &
  echo $! > "$PIDFILE"
}

get_network() {
  sleep 1  # wait for state to settle
  
  signal=$(nmcli -f in-use,signal dev wifi | rg "\*" | awk '{ print $2 }')
  essid=$(nmcli -t -f NAME connection show --active | head -n1 | sed 's/\"/\\"/g')
  radio=$(nmcli radio wifi)

  # read previous state
  if [ -f "$STATEFILE" ]; then
    prev_radio=$(cat "$STATEFILE" | jq -r '.radio')
    prev_essid=$(cat "$STATEFILE" | jq -r '.essid')
  else
    prev_radio="$radio"
    prev_essid="${essid:-lo}"
  fi

  # detect state changes and show notif
  if [ "$radio" = "enabled" ] && [ "$prev_radio" = "disabled" ]; then
    show_notif "Wi-Fi turned on" ""
  elif [ "$radio" = "disabled" ] && [ "$prev_radio" = "enabled" ]; then
    show_notif "Wi-Fi turned off" ""
  elif [ "${essid:-lo}" != "lo" ] && [ "$prev_essid" = "lo" ] && [ "$radio" = "enabled" ]; then
    show_notif "Connected to ${essid}" ""
  elif [ "${essid:-lo}" = "lo" ] && [ "$prev_essid" != "lo" ] && [ "$radio" = "enabled" ]; then
    show_notif "Disconnected" ""
  fi

  # save current state
  jq -n \
    --arg essid "${essid:-lo}" \
    --arg radio "$radio" \
    '{essid: $essid, radio: $radio}' > "$STATEFILE"

  eww update network-radio-optimistic=$([ "$radio" = "enabled" ] && echo true || echo false)

  JSON_STRING=$(jq -n \
    --arg essid "${essid:-lo}" \
    --arg signal "$signal" \
    --arg radio "$radio" \
    '{essid: $essid, signal: $signal, radio: $radio}')
  echo $JSON_STRING
}

get_network

# run both monitors in parallel
(nmcli monitor | grep --line-buffered -E "connectivity|activated|deactivated|wifi|wireless" | while read -r _; do
  get_network
done) &

(ip monitor link | while read -r _; do
  get_network
done) &

wait