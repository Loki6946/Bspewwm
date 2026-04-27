#!/bin/bash

state=$(eww get vol-popup-open)

open_vol() {
  if ! eww active-windows | grep -q "vol-popup"; then
    eww open vol-popup
  fi
  eww update vol-popup-open=true
}

close_vol() {
  eww close vol-popup
  eww update vol-popup-open=false
}

case $1 in
  close)
    close_vol
    exit 0;;
esac

case $state in
  true)
    close_vol;;
  false)
    open_vol;;
esac