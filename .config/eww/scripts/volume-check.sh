#!/bin/bash

vol="$(eww get volume-data)"

if [[ $(eww get volume-popup-open) == false ]]; then
  eww open volume-popup
  eww update volume-popup-open=true
fi

while true; do
  sleep 1.5

  new_vol=$(eww get volume-data)

  if [ "$vol" != "$new_vol" ]; then
    vol="$new_vol"
  else
    newest_vol=$(eww get volume-data)
    if [ "$vol" == "$newest_vol" ]; then
      if [[ $(eww get volume-popup-open) == true ]];then
        eww update volume-popup-open=false
        eww close volume-popup
        exit
      fi
    fi
  fi
done