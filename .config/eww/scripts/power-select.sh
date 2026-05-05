#!/bin/bash

action="$1"
name="$2"

# close the powermenu popup
eww update power-popup-open=false
eww close power-popup

# store action + name and open confirm
eww update power-pending-action="$action"
eww update power-pending-name="$name"
if ! eww active-windows | grep -q "power-confirm"; then
  eww open power-confirm
fi
eww update power-confirm-open=true