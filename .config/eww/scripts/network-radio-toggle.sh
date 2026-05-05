#!/bin/bash

radio=$(nmcli radio wifi)
if [ "$radio" = "enabled" ]; then
  nmcli radio wifi off
else
  nmcli radio wifi on
fi
