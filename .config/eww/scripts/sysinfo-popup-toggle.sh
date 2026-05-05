#!/bin/bash

state=$(eww get sysinfo-popup-open)

open_sysinfo() {
  if ! eww active-windows | grep -q "sysinfo-popup"; then
    eww open sysinfo-popup
  fi
  eww update sysinfo-popup-open=true
}

close_sysinfo() {
  eww close sysinfo-popup
  eww update sysinfo-popup-open=false
}

case $1 in
  close)
    close_sysinfo
    exit 0;;
esac

case $state in
  true)
    close_sysinfo;;
  false)
    open_sysinfo;;
esac