#!/bin/zsh

padding="   "

color_background="#66000000"
color_foreground="#FFFFFFFF"
color_accent="#4DB6AC"

panel_height=28
panel_font="Roboto:size=10"
panel_font_bold="Roboto Medium:size=10"
panel_font_condensed="Roboto Condensed:size=10"
panel_icon_font="Material\-Design\-Iconic\-Font:style=Design-Iconic-Font:size=11"
panel_icon_font_2="Material Design Icons:size=12"

panel_fifo=/tmp/panel-fifo
bar_parser=~/dotfiles/scripts/bar_parser_i3.sh

# check if panel is already running
if [[ $(pgrep -cx lemonbar) -gt 1 ]]; then
	printf "%s\n" "The panel is already running." >&2
	exit 1
fi

# remove old panel fifo, creat new one
[ -e "$panel_fifo" ] && rm "$panel_fifo"
mkfifo "$panel_fifo"

icon() {
    echo -n -e "\u$1"
}

# Window Title
xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/A\1/p' > "${panel_fifo}" &

# Workspace infos
while true; do
  wm_infos=$(i3-msg -t get_workspaces)
  workspaces=$(echo $wm_infos | jq '. | length')
  wm_first=""
	wm_last=""
	last_screen="0"
  for ((i=0; i < $workspaces; i++))
  do
    name=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].name')
    focused=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].focused')
    urgent=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].urgent')
		output=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].output')
    if [ "$urgent" = "true" ]; then
      wm_text="%{F$color_foreground}%{B$color_background}%{U$color_accent}%{+u}%{A:i3-msg 'workspace ${name}':}${padding}${name}${padding}%{A}%{-u}%{B-}%{F-}"
    elif [ "$focused" = "true" ]; then
      wm_text="%{F$color_foreground}%{B$color_background}%{U$color_foreground}%{+u}%{A:i3-msg 'workspace ${name}':}${padding}${name}${padding}%{A}%{-u}%{B-}%{F-}"
    else
      wm_text="%{F$color_foreground}%{B$color_background}%{A:i3-msg 'workspace ${name}':}${padding}${name}${padding}%{A}%{B-}%{F-}"
    fi
		if [ "$output" = "HDMI1" ]; then
      wm_first="$wm_first$wm_text"
	    last_screen=1
		else
			wm_last="$wm_last$wm_text"
	  fi
  done
  echo "W%{Sl}$wm_last%{Sf}$wm_first"
  sleep 0.1
done > "$panel_fifo" &

# Clock
while true; do
  datetime=$(date '+%a, %d. %B - %H:%M')
  echo "C%{T2}$datetime"
  sleep 1
done > "$panel_fifo" &

# Redshift
while true; do
  read redhift_status < /tmp/redshift-status
  if [ $redhift_status = "1" ]; then
    echo "R${padding}%{T5}%{A:pkill -USR1 redshift && echo 0 > /tmp/redshift-status:}$(icon f1c4)%{A}${padding}"
  else
    echo "R${padding}%{T5}%{A:pkill -USR1 redshift && echo 1 > /tmp/redshift-status:}$(icon f1c5)%{A}${padding}"
  fi
  sleep 0.2
done > "$panel_fifo" &

# Volume
while true; do
  mute=$(pactl list sinks | grep "Mute: yes")
  vol=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
  if [ -n "$mute" ]; then
    volume_icon=$(icon f5ff)
  elif [ $vol -ge 50 ]; then
    volume_icon=$(icon f5fc)
  elif [ $vol -ne 0 ]; then
    volume_icon=$(icon f5fe)
  else
    volume_icon=$(icon f5fd)
  fi
  echo "V${padding}%{T5}$volume_icon %{T3}$vol%${padding}"
  sleep 0.2
done > "$panel_fifo" &

# Load
while true; do
  avgload=$(cut -d " " -f 1-3 /proc/loadavg)
  echo "L${padding}%{T5}$(icon f413) %{T3}$avgload${padding}"
  sleep 1
done > "$panel_fifo" &

# Update counter
while true; do
  update_count=$(pacman -Qu | wc -l)
  if [ $update_count -ne 0 ]; then
    echo "U${padding}%{T5}$(icon f482) %{T3}$update_count Updates${padding}"
  else
    echo "U"
  fi
  sleep 900
done > "$panel_fifo" &

# Network
while true; do
	echo "N$(cat /sys/class/net/wlp0s29u1u5/statistics/rx_bytes)"
	sleep 1
done > "$panel_fifo" &

"$bar_parser" < "$panel_fifo" | lemonbar \
  -g x"$panel_height" \
  -F "$color_foreground" \
  -B "$color_background" \
  -u 2 \
  -o -1 \
  -f "$panel_font" \
  -f "$panel_font_bold" \
  -f "$panel_font_condensed" \
  -f "$panel_icon_font" \
  -f "$panel_icon_font_2" | zsh

wait
