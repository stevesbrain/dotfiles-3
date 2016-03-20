#!/bin/bash
while true; do
  color="#CBCDD2"
  if [[ $1 -eq $(printf 0x%x $(xdotool getactivewindow)) ]]; then
    color="#99ccff"
  fi
  title=$(xtitle $1)
  echo -e "%{F$color}%{c}%{A2:bspc window $1 -c:}%{A5:bspc window $1 -d last:}%{A4:bspc window $1 -s biggest && ~/.config/bspwm/titlebars.sh:}$title%{A}%{A}%{A}%{F-}%{r}%{A:bspc window $1 -c:}  %{T2}  \u2715 %{T1}   %{A}"
  sleep 0.5
done
