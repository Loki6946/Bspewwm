#!/bin/bash

# kill previous instance
pkill -f "pactl subscribe" 2>/dev/null
sleep 0.1

pamixer --get-volume-human | tr -d '%'

pactl subscribe | rg --line-buffered "on sink" | while read -r _; do
  pamixer --get-volume-human | tr -d '%'
done