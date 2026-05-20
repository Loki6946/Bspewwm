#! /bin/bash

get_color() {
  theme=$(grep "@import" ~/.config/eww/_color.scss | grep -o '"themes/[^"]*"' | tr -d '"' | sed 's|themes/||')
  awk -F'[ :;#]+' -v name="$1" '$0 ~ "^\\$" name ":"{print $2}' ~/.config/eww/themes/_${theme}.scss
}

get_color $@
