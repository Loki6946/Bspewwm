#! /bin/bash

# variables
get_color="$HOME/.config/bspwm/bspwm.d/get-color.sh"
set_resolution="$HOME/.set-resolution.sh"
eww_cleanup="$HOME/.config/eww/scripts/eww-cleanup.sh"

# autostart

# kill if already running
killall -9 sxhkd vicinae eww picom xcorners

# start shortcut manager
sxhkd &

# set custom resolution
source $set_resolution &

# wait for resolution to set
until xrandr | grep "1360x768"; do
    sleep 0.2
done

# set wallpaper
nitrogen --restore &

# start picom compositor
picom &

# set rounded wallpaper
xcorners -y 30 -r 16 -c $($get_color background)FF -1 &

# fix cursor
xsetroot -cursor_name left_ptr &

# disable mouse acceleration
xinput set-prop "8" "libinput Accel Profile Enabled" 0 1 0 &

# start vicinae app launcher server
vicinae server &

# start eww
source $eww_cleanup &
eww daemon &
eww open bar &
