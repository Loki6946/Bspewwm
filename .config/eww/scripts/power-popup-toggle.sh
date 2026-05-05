#!/bin/bash

state=$(eww get power-popup-open)

open_power() {
  if ! eww active-windows | grep -q "power-popup"; then
    eww open power-popup
  fi
  eww update power-popup-open=true
}

close_power() {
  eww close power-popup
  eww update power-popup-open=false
}

case $1 in
  close)
    close_power
    exit 0;;
esac

case $state in
  true)
    close_power;;
  false)
    open_power;
esac