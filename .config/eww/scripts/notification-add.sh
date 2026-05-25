#!/bin/bash

LOCK="/tmp/notification-lock"

exec 200>"$LOCK"
flock -w 2 200 || exit 1

APP="$DUNST_APP_NAME"
SUMMARY="$DUNST_SUMMARY"
BODY="$DUNST_BODY"
URGENCY="$DUNST_URGENCY"
TIME=$(date "+%H:%M")

# generate unique ID — timestamp + random
ID="$(date +%s%N)_$RANDOM"

current=$(eww get notifications 2>/dev/null)
[[ "$current" == "" || "$current" == "null" ]] && current="[]"

new_notif=$(jq -cn \
  --arg id "$ID" \
  --arg app "$APP" \
  --arg summary "$SUMMARY" \
  --arg body "$BODY" \
  --arg time "$TIME" \
  '{id: $id, app: $app, summary: $summary, body: $body, time: $time}')

updated=$(jq -cn \
  --argjson notif "$new_notif" \
  --argjson current "$current" \
  '[$notif] + $current')

eww update notifications="$updated"

if ! eww active-windows | grep -q "notification-center"; then
  eww open notification-center
fi

flock -u 200

case "$URGENCY" in
  LOW)    timeout=5  ;;
  NORMAL) timeout=8  ;;
  *)      timeout=0  ;;
esac

if [[ "$timeout" -gt 0 ]]; then
  (sleep "$timeout" && ~/.config/eww/scripts/notification-dismiss.sh "$ID") &
fi