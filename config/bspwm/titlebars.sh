#!/bin/bash
# use lemonboys bar to display titlebars

barPids=/tmp/titleBarPids
touch $barPids

wininfo=$(bspc query -T)
windows=""

SAFEIFS=$IFS
IFS=$'\n'
for i in $wininfo; do
  if [[ $i =~ ^$(printf "\t")[0-9] ]] && [[ $i =~ '*' ]]; then
    windows="$windows $(bspc query -W -d $(echo $i | awk '{print $1}'))"
    windows="$windows M"
  fi
done

if [[ "$windows" == "" ]];then
    kill $(cat $barPids)
    rm $barPids
    exit
fi

IFS=$SAFEIFS

OLDEST_PID=$(pgrep -o 'lemonbar')
test $OLDEST_PID && pgrep 'lemonbar' | grep -vw $OLDEST_PID | xargs -r kill

for proc in $(pgrep 'update-title.sh');do
  echo $proc
  kill $proc
done

rm $barPids
sleep 0.1
blankscreen=false
for id in $windows; do
  if [[ $id == "M" ]]; then
    blankscreen=false
    continue
  elif [[ $blankscreen == true ]]; then
    continue
  fi
  if [[ "$(xprop WM_CLASS -id $id)" =~ "Steam" ]]; then
    continue
  fi
  x=$(xwininfo -id $id | grep "Absolute upper-left X" | awk '{print $4}')
  y=$(xwininfo -id $id | grep "Absolute upper-left Y" | awk '{print $4}')
  w=$(xwininfo -id $id | grep "Width" | awk '{print $2}')
  h=$(xwininfo -id $id | grep "Height" | awk '{print $2}')
  geo="${w}x${h}+${x}+${y}"
  geoBar=$(echo $geo| sed -e 's/+\|x/ /g'| awk '{print $1"x32+"$3"+"$4-32}')
  if [ "$h" -lt "1024" ]; then
    ~/.config/bspwm/update-title.sh $id| lemonbar -g $geoBar -f "Source Sans Pro Semibold:size=10" -f "Deja Vu Sans:size=9" -p -d -B "#2E3237" -F "#CBCDD2" | bash &
  else
    blankscreen=true
  fi
done
