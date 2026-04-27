#!/bin/bash

action="$1"
name="$2"

# close the powermenu popup
eww update pow-popup-open=false
eww close pow-popup

# store action + name and open confirm
eww update pow-pending-action="$action"
eww update pow-pending-name="$name"
if ! eww active-windows | grep -q "pow-confirm"; then
  eww open pow-confirm
fi
eww update pow-confirm-open=true