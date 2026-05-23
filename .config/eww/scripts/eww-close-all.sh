#!/bin/bash

# get all open windows except bar, extract just the window name
windows=$(eww active-windows | grep -v "bar" | awk -F': ' '{print $1}')

if [ -z "$windows" ]; then
  exit 0
fi

while IFS= read -r window; do
  case $window in
    network-popup)
      eww close network-popup
      eww update network-popup-open=false
      ;;
    power-popup)
      eww close power-bg
      eww close power-popup
      eww update power-popup-open=false
      eww update power-pending-name=""
      eww update power-pending-action=""
      ;;
    sysinfo-popup)
      eww close sysinfo-popup
      eww update sysinfo-popup-open=false
      ;;
    volume-popup)
      eww close volume-popup
      eww update volume-popup-open=false
      ;;
    screenshot-popup)
      eww close screenshot-popup
      eww update screenshot-popup-open=false
      ;;
    color-picker-popup)
      eww close color-picker-popup
      eww update color-picker-popup-open=false
      ;;
    calendar-popup)
      eww close calendar-popup
      eww update calendar-popup-open=false
      ;;
  esac
done <<< "$windows"