#!/bin/bash

# cpu — single awk pass instead of grep + awk + sed + xargs
cpu_name=$(awk -F': ' '/model name/{gsub(/\(R\)|\(TM\)| CPU/,"",$2); print $2; exit}' /proc/cpuinfo)

# gpu — single lspci call instead of two
gpu_info=$(lspci | grep -i 'vga\|3d\|display' | head -n1)
gpu_vendor=$(echo "$gpu_info" | grep -oi 'nvidia\|amd\|intel')
gpu_model=$(echo "$gpu_info" | sed 's/.*\[//;s/\].*//')
gpu_name="$gpu_vendor $gpu_model"

# os — read directly instead of sourcing
os=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)

# kernel — keep as is, uname is fast
kernel=$(uname -r)

# ram — keep as is
total_ram=$(free -m | awk '/Mem/{print $2"MB"}')

# uptime — already uses /proc/uptime which is optimal
uptime_seconds=$(awk '{print int($1)}' /proc/uptime)
hours=$((uptime_seconds / 3600))
minutes=$(( (uptime_seconds % 3600) / 60 ))
uptime="${hours}h ${minutes}m"

# user info — use $USER instead of whoami (builtin)
username="${USER}"
hostname="${HOSTNAME}"
shell=$(basename "$SHELL")
wm="bspwm"
terminal=$(xdotool getactivewindow getwindowname 2>/dev/null | grep -oi 'alacritty\|kitty\|foot\|wezterm\|ghostty' | head -n1)
terminal="${terminal:-alacritty}"

JSON_STRING=$(jq -cn \
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
echo "$JSON_STRING"