eww update wallpaper-refreshing=true
eww poll wallpaper-list
bash ~/.config/eww/scripts/wallpaper-thumbs-generate.sh

sleep 3

# close and reopen picker to refresh
if eww active-windows | grep -q "wallpaper-picker"; then
  eww close wallpaper-picker
  sleep 0.3
  eww update wallpaper-refreshing=false
  eww open wallpaper-picker
fi