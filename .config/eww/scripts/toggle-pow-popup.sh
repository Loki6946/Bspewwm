#!/bin/bash

state=$(eww get pow-popup-open)

open_pow() {
  if ! eww active-windows | grep -q "pow-popup"; then
    eww open pow-popup
  fi
  eww update pow-popup-open=true
}

close_pow() {
  eww close pow-popup
  eww update pow-popup-open=false
}

case $1 in
  close)
    close_pow
    exit 0;;
esac

case $state in
  true)
    close_pow;;
  false)
    open_pow;;
esac