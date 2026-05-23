#!/bin/bash

xkblayout-state print "%s"

xev -root | grep --line-buffered "XkbMapNotify" | while read -r _; do
  xkblayout-state print "%s"
done
