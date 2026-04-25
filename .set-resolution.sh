#!/bin/bash

xrandr --newmode "1360x768_60.00" 84.75 1366 1431 1567 1776 768 771 781 798 -hsync +vsync 2>/dev/null
xrandr --addmode DVI-I-2 "1360x768_60.00" 2>/dev/null
xrandr --output DVI-I-2 --mode "1360x768_60.00"
