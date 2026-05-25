#!/bin/bash

ID="$1"

current=$(eww get notifications 2>/dev/null)
[[ "$current" == "[]" || "$current" == "" || "$current" == "null" ]] && exit 0

updated=$(jq -cn \
  --arg id "$ID" \
  --argjson current "$current" \
  '$current | map(select(.id != $id))')

eww update notifications="$updated"

if [[ "$updated" == "[]" ]]; then
  eww close notification-center
fi