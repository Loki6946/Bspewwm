#!/bin/sh

# Output only the currently focused workspace name

focused_workspace() {
    bspc query -D -d focused --names
}

focused_workspace

bspc subscribe desktop node_transfer node_focus | while read -r _; do
    focused_workspace
done
