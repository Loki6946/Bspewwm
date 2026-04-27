#!/bin/bash
action=$(eww get pow-pending-action)
eww update pow-confirm-open=false
eww close pow-confirm
eww update pow-popup-open=false
eww close pow-popup
sleep 0.2  # wait for animation
$action