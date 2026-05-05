#!/bin/bash
action=$(eww get power-pending-action)
eww update power-confirm-open=false
eww close power-confirm
eww update power-popup-open=false
eww close power-popup
sleep 0.2  # wait for animation
$action