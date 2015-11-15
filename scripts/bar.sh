#!/bin/sh

padding="    "

color_background="#66000000"
color_foreground="#FFFFFFFF"
color_accent="#66FFFFFF"

panel_height=32
panel_font="Roboto:size=10"
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

{
  while true; do

    buf=""
    buf="$buf %{l}%{T1}$(workspaces)"
    buf="$buf %{c}%{T2}$(clock)"
    buf="$buf %{T4}$(icon f1c4)"
    echo -e "$buf"

    sleep 0.2;
  done
} | lemonbar \
  -g x"$panel_height" \
  -F "$color_foreground" \
  -B "$color_background" \
  -u 2 \
  -o -2 \
  -f "$panel_font" \
  -f "$panel_font_bold" \
  -f "$panel_icon_font" \
  -f "$panel_icon_font_2" | zsh
