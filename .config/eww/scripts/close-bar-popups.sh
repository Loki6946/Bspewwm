#!/bin/bash
# closes all bar-anchored popups

eww close volume-popup 2>/dev/null
eww update volume-popup-open=false
eww close network-popup 2>/dev/null
eww update network-popup-open=false
eww close calendar-popup 2>/dev/null
eww update calendar-popup-open=false