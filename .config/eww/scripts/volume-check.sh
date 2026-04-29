#!/bin/bash

vol="$(eww get volume-data)"

if [[ $(eww get vol-popup-open) == false ]]; then
  eww open vol-popup
  eww update vol-popup-open=true
fi

while true; do
  sleep 1.5

  new_vol=$(eww get volume-data)

  if [ "$vol" != "$new_vol" ]; then
    vol="$new_vol"
  else
    newest_vol=$(eww get volume-data)
    if [ "$vol" == "$newest_vol" ]; then
      if [[ $(eww get vol-popup-open) == true ]];then
        eww update vol-popup-open=false
        eww close vol-popup
        exit
      fi
    fi
  fi
done