#!/bin/sh

padding="   "

color_background="#33000000"
color_foreground="#FFFFFFFF"
color_accent="#66FFFFFF"

panel_height=24
panel_font="Roboto Condensed:size=10"
panel_font_bold="Roboto Medium:size=10"
panel_icon_font="Material\-Design\-Iconic\-Font:style=Design-Iconic-Font:size=12"
panel_icon_font_2="Material Design Icons:size=12"

icon() {
    echo -n -e "\u$1"
}

# Workspace infos
workspaces() {
  wm_infos=$(i3-msg -t get_workspaces)
  workspaces=$(echo $wm_infos | jq '. | length')
  wm_output=""

  for ((i=0; i < $workspaces; i++))
  do
    name=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].name')
    focused=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].focused')
    urgent=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].urgent')
    if [ "$urgent" = "true" ]; then
      wm_output="$wm_output%{F$color_foreground}%{B$color_background}%{U$color_accent}%{+u}%{A:i3-msg 'workspace ${name}':}${padding}${name}${padding}%{A}%{-u}%{B-}%{F-}"
    elif [ "$focused" = "true" ]; then
      wm_output="$wm_output%{F$color_foreground}%{B$color_background}%{U$color_foreground}%{+u}%{A:i3-msg 'workspace ${name}':}${padding}${name}${padding}%{A}%{-u}%{B-}%{F-}"
    else
      wm_output="$wm_output%{F$color_foreground}%{B$color_background}%{A:i3-msg 'workspace ${name}':}${padding}${name}${padding}%{A}%{B-}%{F-}"
    fi
  done
  echo "$wm_output"
}

clock() {
  date '+%a, %d. %B - %H:%M'
}

cpu() {
  LINE=`ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'`
  bc <<< $LINE
}

redshift_control() {
  read redhift_status < redshift-status
  if [ $redhift_status = "1" ]; then
    echo "${padding}%{T4}%{A:pkill -USR1 redshift && echo 0 > redshift-status:}$(icon f1c4)%{A}${padding}"
  else
    echo "${padding}%{T4}%{A:pkill -USR1 redshift && echo 1 > redshift-status:}$(icon f1c5)%{A}${padding}"
  fi
}

volume() {
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

  echo "${padding}%{T4}$volume_icon %{T1}$vol%${padding}"

}

load_avg() {
  avgload=$(cut -d " " -f 1-3 /proc/loadavg)
  echo "${padding}%{T4}$(icon f413) %{T1}$avgload${padding}"
}

# TODO: figure out how fifo works.
# update_timer=0
# update_count=0
# updates() {
#   ((update_timer++))
#   if [ $update_timer -gt 10 ]; then
#     update_count=$(pacman -Qu | wc -l)
#     update_timer=0
#   fi
#   if [ $update_count -ne 0 ]; then
#     echo "${padding}%{T4}$(icon f482) %{T1}$update_count Updates${padding}"
#   else
#     echo -n "$update_timer"
#   fi
# }

{
  while true; do

    buf=""
    buf="$buf %{l}%{T1}$(workspaces)"
    buf="$buf %{c}%{T2}$(clock)"
    buf="$buf %{r}$(volume)"
    buf="$buf $(load_avg)"
    buf="$buf $(redshift_control)"
    echo -e "$buf"

    sleep 0.2;
  done
} | lemonbar \
  -g x"$panel_height" \
  -F "$color_foreground" \
  -B "$color_background" \
  -u 2 \
  -o -1 \
  -f "$panel_font" \
  -f "$panel_font_bold" \
  -f "$panel_icon_font" \
  -f "$panel_icon_font_2" | zsh
