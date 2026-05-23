#!/bin/bash
if eww active-windows | grep -q "wallpaper-picker"; then
  eww close wallpaper-picker
  eww update wallpaper-picker-open=false
else
  eww open wallpaper-picker
  eww update wallpaper-picker-open=true
fi