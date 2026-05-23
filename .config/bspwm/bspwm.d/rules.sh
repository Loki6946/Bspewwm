#! /bin/sh

# manage all the unmanaged windows remaining from a previous session.
bspc wm --adopt-orphans

# remove all rules first
bspc rule -r *:*

# general app rules
bspc rule -a vicinae state=floating follow=on focus=on border=false
bspc rule -a Gnome-screenshot state=floating border=off center=on
bspc rule -a Nitrogen state=floating border=off center=on

# disable rounded corner on monocle layout
pkill -f "bspc subscribe desktop_layout" 2>/dev/null

bspc subscribe desktop_layout | while read -r Event
do
  Desktop=$(echo "$Event" | awk '{print $3}')
  State=$(echo "$Event" | awk '{print $4}')
  if [ "$State" = "monocle" ]; then
    bspc query -N -d $Desktop | while read -r Node
    do
      xprop -id $Node -f _PICOM_ROUNDED 32c -set _PICOM_ROUNDED 1
    done
  elif [ $(bspc config window_gap) -gt 0 ]; then
    bspc query -N -d $Desktop | while read -r Node
    do
      xprop -id $Node -remove _PICOM_ROUNDED
    done
  fi
done &
