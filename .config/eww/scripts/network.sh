#!/bin/bash

STATEFILE="/tmp/network-state.tmp"

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
    notify-send "Network" "Wi-Fi turned on"
  elif [[ "$radio" == "disabled" && "$prev_radio" == "enabled" ]]; then
    notify-send "Network" "Wi-Fi turned off"
  elif [[ "${essid:-lo}" != "lo" && "$prev_essid" == "lo" && "$radio" == "enabled" ]]; then
    notify-send "Network" "Connected to ${essid}"
  elif [[ "${essid:-lo}" == "lo" && "$prev_essid" != "lo" && "$radio" == "enabled" ]]; then
    notify-send -u critical "Network" "Disconnected"
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