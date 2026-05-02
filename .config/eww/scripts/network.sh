#!/bin/bash

# signal=$(nmcli -f in-use,signal dev wifi | rg "\*" | awk '{ print $2 }')
# essid=$(nmcli -t -f NAME connection show --active | head -n1 | sed 's/\"/\\"/g')
# echo '{"essid": "'"$essid"'", "signal": "'"$signal"'"}'

# ip monitor link | while read -r line; do
#     signal=$(nmcli -f in-use,signal dev wifi | rg "\*" | awk '{ print $2 }')
#     essid=$(nmcli -t -f NAME connection show --active | head -n1 | sed 's/\"/\\"/g')
#     echo '{"essid": "'"$essid"'", "signal": "'"$signal"'"}'
# done

get_network() {
  signal=$(nmcli -f in-use,signal dev wifi | rg "\*" | awk '{ print $2 }')
  essid=$(nmcli -t -f NAME connection show --active | head -n1 | sed 's/\"/\\"/g')
  radio=$(nmcli radio wifi)

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