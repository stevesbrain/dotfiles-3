#!/bin/sh
function linear() {
  echo "($X + $@) - ($T - 1) * $@" | bc
}

function binary() {
  echo "($X * 2) / (2  *($T -1)) + 32" | bc
}

function pitch() {
  echo "$X * 0.25 / 0.282" | bc
}

function resolution() {
  echo "$X * 1024 / 1280" | bc
}

bspc control --subscribe | while read line; do
  X=48
  P=150
  [[ $(bspc query --monitors --desktop focused) = HDMI1 ]] || X=$(pitch) # alternatively X=$(resolution)
  W=$(bspc query --desktop focused --windows | wc -l)
  F=$(bspc query --desktop focused -T | grep "f-------" | wc -l)
  T=$((W-F))
  if [ $T -eq 1 ]; then
    monitor=$(bspc query -M --monitor focused)
    if [ "$monitor" = "HDMI1" ]; then
      bspc config --desktop focused right_padding $P
      bspc config --desktop focused left_padding $P
    fi
    bspc config --desktop focused window_gap 80
  else
    bspc config --desktop focused right_padding 0
    bspc config --desktop focused left_padding 0
    G=$(binary) # alternatively G=$(linear 10)
    [[ $G -lt 1 ]] && G=80
    bspc config --desktop focused window_gap $G
  fi
done
