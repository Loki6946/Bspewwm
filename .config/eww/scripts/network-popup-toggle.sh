#!/bin/bash

state=$(eww get network-popup-open)

case $state in
  true)
    eww close network-popup
    eww update network-popup-open=false;;
  false)
    eww open network-popup
    eww update network-popup-open=true;;
esac
