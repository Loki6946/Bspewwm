#!/bin/bash

# pick color and copy to clipboard
color=$(gpick -p -s -o)

if [[ -z "$color" ]]; then
  exit 0
fi

echo -n "$color" | xclip -selection clipboard

notify-send "Color Picker" "${color} copied to clipboard"