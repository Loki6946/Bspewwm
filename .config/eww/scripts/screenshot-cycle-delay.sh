#!/bin/bash
current=$(eww get screenshot-delay)

case $current in
  0) eww update screenshot-delay=1 ;;
  1) eww update screenshot-delay=3 ;;
  3) eww update screenshot-delay=5 ;;
  5) eww update screenshot-delay=0 ;;
  *) eww update screenshot-delay=0 ;;
esac