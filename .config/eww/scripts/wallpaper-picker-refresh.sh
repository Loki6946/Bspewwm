eww poll wallpaper-list
bash ~/.config/eww/scripts/wallpaper-thumbs-generate.sh

sleep 2

# close and reopen picker to refresh
if eww active-windows | grep -q "wallpaper-picker"; then
  eww close wallpaper-picker
  sleep 0.3
  eww open wallpaper-picker
fi