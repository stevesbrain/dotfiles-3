#!/bin/bash
# use lemonboys bar to display titlebars

barPids=/tmp/titleBarPids
touch $barPids

wininfo=$(bspc query -T)
windows=""

SAFEIFS=$IFS
IFS=$'\n'
echo $wininfo
for i in $wininfo; do
  if [[ $i =~ ^$(printf "\t")[0-9] ]] && [[ $i =~ '*' ]]; then
    windows="$windows $(bspc query -W -d $(echo $i | awk '{print $1}'))"
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


rm $barPids
sleep 0.02
for id in $windows; do
    echo $id
    echo "title: $(xtitle $id)"
    x=$(xwininfo -id $id | grep "Absolute upper-left X" | awk '{print $4}')
    y=$(xwininfo -id $id | grep "Absolute upper-left Y" | awk '{print $4}')
    w=$(xwininfo -id $id | grep "Width" | awk '{print $2}')
    h=$(xwininfo -id $id | grep "Height" | awk '{print $2}')
    geo="${w}x${h}+${x}+${y}"
    echo "geo: $geo"
    geoBar=$(echo $geo| sed -e 's/+\|x/ /g'| awk '{print $1"x32+"$3"+"$4-32}')
    echo "geoBar: $geoBar"
    if [ "$h" -lt "1024" ]; then
      ~/.config/bspwm/update-title.sh $id| lemonbar -g $geoBar -f "Roboto:size=9" -f "Deja Vu Sans:size=9" -p -d -B "#2E3237" -F "#CBCDD2" | bash &
    fi
done
