#!/bin/bash

get_volume() {
  pamixer --get-volume-human | tr -d '%'
}

get_volume

pactl subscribe | grep --line-buffered "on sink" | while read -r _; do
  get_volume
done