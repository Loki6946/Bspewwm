#!/bin/bash

base_dir="$HOME/.config/eww/"

playerctl metadata -F -f '{{playerName}} {{title}} {{artist}} {{mpris:artUrl}} {{status}} {{mpris:length}}' | while read -r line; do
    name=$(playerctl metadata -f "{{playerName}}")
    title=$(playerctl metadata -f "{{title}}")
    artist=$(playerctl metadata -f "{{artist}}")
    artUrl=$(playerctl metadata -f "{{mpris:artUrl}}")
    status=$(playerctl metadata -f "{{status}}")
    length=$(playerctl metadata -f "{{mpris:length}}")

    # builtin arithmetic instead of bc
    if [[ -n "$length" ]]; then
        length=$(( (length + 500000) / 1000000 ))
    fi

    rm -f "${base_dir}image.jpg"

    # use [[ ]] instead of [[ ]]
    if [[ "$artUrl" == file://* ]]; then
        local_path=$(python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1]))" "${artUrl#file://}")
        cp "$local_path" "${base_dir}image.jpg" 2>/dev/null || true
    elif [[ "$artUrl" == http* ]]; then
        wget -q -O "${base_dir}image.jpg" "$artUrl"
    fi
    
    lengthStr=$(playerctl metadata -f "{{duration(mpris:length)}}")

    JSON_STRING=$(jq -cn \
                --arg name "$name" \
                --arg title "$title" \
                --arg artist "$artist" \
                --arg artUrl "${base_dir}image.jpg" \
                --arg status "$status" \
                --arg length "$length" \
                --arg lengthStr "$lengthStr" \
                '{name: $name, title: $title, artist: $artist, artUrl: $artUrl, status: $status, length: $length, lengthStr: $lengthStr}')
    echo "$JSON_STRING"
done