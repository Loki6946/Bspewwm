#!/bin/bash
state=$(eww get cal-popup-open)
case $state in
  true)
    eww close cal-popup
    eww update cal-popup-open=false;;
  false)
    eww open cal-popup
    eww update cal-popup-open=true;;
esac