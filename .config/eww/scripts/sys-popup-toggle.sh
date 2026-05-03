#!/bin/bash

state=$(eww get sys-popup-open)

open_sys() {
  if ! eww active-windows | grep -q "sys-popup"; then
    eww open sys-popup
  fi
  eww update sys-popup-open=true
}

close_sys() {
  eww close sys-popup
  eww update sys-popup-open=false
}

case $1 in
  close)
    close_sys
    exit 0;;
esac

case $state in
  true)
    close_sys;;
  false)
    open_sys;;
esac