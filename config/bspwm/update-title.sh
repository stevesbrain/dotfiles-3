#!/bin/bash
while true; do
  color="#CBCDD2"
  if [[ $1 -eq $(printf 0x%x $(xdotool getactivewindow)) ]]; then
    color="#FB4757"
  fi
  echo -e "%{F$color}%{c}$(xtitle $1)%{F-}%{r}%{A:bspc window $1 -c:}  %{T2}  \u2715 %{T1}   %{A}"
  sleep 0.5
done
