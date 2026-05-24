#!/bin/bash

PIDFILE="/tmp/network-notif-timer.pid"
STATEFILE="/tmp/network-state.tmp"

show_notif() {
  local message="$1"
  local icon="$2"

  # kill previous timer using [[ ]]
  if [[ -f "$PIDFILE" ]]; then
    kill $(cat "$PIDFILE") 2>/dev/null
    rm "$PIDFILE"
  fi

  # batch eww updates into one call
  eww update network-notif-message="$message" network-notif-icon="$icon" network-notif-open=true
  eww open network-notif

  (sleep 5 && eww update network-notif-open=false && eww close network-notif) &
  echo $! > "$PIDFILE"
}

get_network() {
  sleep 0.5  # reduced from 1s

  # single nmcli call for signal — avoid rg subprocess
  signal=$(nmcli -f in-use,signal dev wifi | awk '/\*/{print $2}')
  
  # single nmcli call for essid — replace sed with parameter expansion
  essid=$(nmcli -t -f NAME connection show --active | head -n1)
  essid="${essid//\"/\\\"}"  # parameter expansion instead of sed

  radio=$(nmcli radio wifi)

  # read previous state — single jq call
  if [[ -f "$STATEFILE" ]]; then
    prev_state=$(cat "$STATEFILE")
    prev_radio=$(jq -r '.radio' <<< "$prev_state")
    prev_essid=$(jq -r '.essid' <<< "$prev_state")
  else
    prev_radio="$radio"
    prev_essid="${essid:-lo}"
  fi

  # use [[ ]] instead of [ ]
  if [[ "$radio" == "enabled" && "$prev_radio" == "disabled" ]]; then
    show_notif "Wi-Fi turned on" ""
  elif [[ "$radio" == "disabled" && "$prev_radio" == "enabled" ]]; then
    show_notif "Wi-Fi turned off" ""
  elif [[ "${essid:-lo}" != "lo" && "$prev_essid" == "lo" && "$radio" == "enabled" ]]; then
    show_notif "Connected to ${essid}" ""
  elif [[ "${essid:-lo}" == "lo" && "$prev_essid" != "lo" && "$radio" == "enabled" ]]; then
    show_notif "Disconnected" ""
  fi

  # save state and output JSON in one jq call
  local json
  json=$(jq -cn \
    --arg essid "${essid:-lo}" \
    --arg signal "$signal" \
    --arg radio "$radio" \
    '{essid: $essid, signal: $signal, radio: $radio}')

  # save state
  jq -cn \
    --arg essid "${essid:-lo}" \
    --arg radio "$radio" \
    '{essid: $essid, radio: $radio}' > "$STATEFILE"

  # batch eww update
  eww update network-radio-optimistic=$([[ "$radio" == "enabled" ]] && echo true || echo false)

  echo "$json"
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