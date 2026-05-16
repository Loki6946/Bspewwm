#!/bin/bash
current=$(eww get screenshot-delay)

case $current in
  1) eww update screenshot-delay=3 ;;
  3) eww update screenshot-delay=5 ;;
  5) eww update screenshot-delay=1 ;;
  *) eww update screenshot-delay=1 ;;
esac