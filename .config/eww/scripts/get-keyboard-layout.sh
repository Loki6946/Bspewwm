#!/bin/bash

# kill previous instance
pkill -f "xev -root" 2>/dev/null
sleep 0.1

xkblayout-state print "%s"

xev -root | grep --line-buffered "XkbMapNotify" | while read -r _; do
  xkblayout-state print "%s"
done
