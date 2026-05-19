#!/bin/bash

cpu_name=$(grep -m1 "model name" /proc/cpuinfo | awk -F': ' '{print $2}' | sed 's/(R)//g;s/(TM)//g;s/ CPU//g' | xargs)

gpu_vendor=$(lspci | grep -i 'vga\|3d\|display' | grep -oi 'nvidia\|amd\|intel' | head -n1)
gpu_model=$(lspci | grep -i 'vga\|3d\|display' | sed 's/.*\[//;s/\].*//' | head -n1 | xargs)
gpu_name="$gpu_vendor $gpu_model"

os=$(. /etc/os-release && echo "$PRETTY_NAME")
kernel=$(uname -r)
total_ram=$(free -m | awk '/Mem/{print $2"MB"}')

uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
hours=$((uptime_seconds / 3600))
minutes=$(( (uptime_seconds % 3600) / 60 ))
uptime="${hours}h ${minutes}m"

# user info
username=$(whoami)
hostname=$(hostname)
shell=$(basename "$SHELL")
wm="bspwm"
terminal=$(xdotool getactivewindow getwindowname 2>/dev/null | grep -oi 'alacritty\|kitty\|foot\|wezterm\|ghostty' | head -n1)
terminal=${terminal:-"alacritty"} # fallback if detection fails

JSON_STRING=$(jq -n \
  --arg cpu_name "$cpu_name" \
  --arg gpu_name "$gpu_name" \
  --arg os "$os" \
  --arg kernel "$kernel" \
  --arg total_ram "$total_ram" \
  --arg uptime "$uptime" \
  --arg username "$username" \
  --arg hostname "$hostname" \
  --arg shell "$shell" \
  --arg wm "$wm" \
  --arg terminal "$terminal" \
  '{cpu_name: $cpu_name, gpu_name: $gpu_name, os: $os, kernel: $kernel, total_ram: $total_ram, uptime: $uptime, username: $username, hostname: $hostname, shell: $shell, wm: $wm, terminal: $terminal}')
echo $JSON_STRING