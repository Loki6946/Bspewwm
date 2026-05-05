#!/bin/bash
state=$(eww get calendar-popup-open)
case $state in
  true)
    eww close calendar-popup
    eww update calendar-popup-open=false;;
  false)
    eww open calendar-popup
    eww update calendar-popup-open=true;;
esac