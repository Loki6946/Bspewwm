#!/bin/sh

# Outputs occupied desktop names only

occupied_workspaces() {
    bspc query -D -d .occupied --names | tr '\n' ' '
    echo
}

occupied_workspaces

bspc subscribe desktop node_add node_remove node_transfer node_focus | while read -r _; do
    occupied_workspaces
done
