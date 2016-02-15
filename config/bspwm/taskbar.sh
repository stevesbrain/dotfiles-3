#!/bin/bash
itemLength=30

panel_height=32

normalFg="CBCDD2"
activeBg="#1C1D21"
activeFg="#FB4757"
inactiveBG="#001C1D21"
inactiveFG="#66$normalFg"

# bspc control --subscribe | while read line; do
while true; do

  wininfo=$(bspc query -T)

  IFS=$'\n'

  space=0
  first=true
  empty=true

  monitor=0

  line=""

  pad=$(printf '%0.1s' " "{1..60})

  active=false
  monitoractive=false

  for i in $wininfo; do
    # monitor handling
    if [[ $i =~ ^[HV] ]]; then
      datetime=$(date '+%H:%M')
      line="${line}%{S$monitor}%{r}$datetime  %{l}"
      ((monitor++))
      if [[ $i =~ $(printf "\*\s*$") ]]; then
        monitoractive=true
      fi
    fi
    # check for desktop
    if [[ $i =~ ^$(printf "\t")[0-9] ]]; then
      if [[ $empty == true ]] && [[ $active == true ]]; then
        line="${line}%{F${activeFg}}  $space  %{F-}"
        active=false
      fi
      if [[ $i =~ $(printf "\*\s*$") ]]; then
        active=true
      else
        active=false
      fi
      ((space++))
      empty=true
      first=true
    fi
    # check for windows
    if [[ $i == *"	m "* ]] || [[ $i == *"	c "* ]] || [[ $i == *"	a "* ]]; then
      if [[ $first == true ]]; then
        if [[ $active == true ]]; then
          line="${line}%{F${activeFg}}"
      	else
      	  line="${line}%{F${inactiveFG}}"
        fi
        line="${line}  $space  "
        first=false
      	line="${line}%{F-}"
      fi
      # active window
      if [[ $active == true ]] && [[ $monitoractive == true ]]; then
        if [[ $i =~ $(printf "\*\s*$") ]]; then
          line="${line}%{F${activeFg}}%{B${activeBg}}"
        fi
      fi
      # get window name
      while IFS=" " read -r id rest; do
        window="$(xprop -id $id | grep '^_NET_WM_NAME(UTF' | sed -e 's/_NET_WM_NAME(UTF8_STRING) = "//' -e 's/\"$//' | awk -v len=$itemLength '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }')"
        if [ -z $window ]; then
          window="$(xprop -id $id | grep '^WM_NAME(UTF' | sed -e 's/WM_NAME(.*) = "//' -e 's/\"$//' | awk -v len=$itemLength '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }')"
        fi
        padding=$(printf '%*.*s' 0 $(((itemLength - ${#window}) )) "$pad")
        line="${line}%{A:bspc window -f $id:}$padding    $window    $padding%{A}"
      done <<< "$(echo $i | grep -o '0x.* ')"
      # close active window
      if [[ $active == true ]] && [[ $monitoractive == true ]]; then
        if [[ $i =~ $(printf "\*\s*$") ]]; then
          line="${line}%{B-}%{F-}"
          active=false
          monitoractive=false
        fi
      fi
      empty=false
    fi
  done
  if [[ $first == true ]] && [[ $active == true ]]; then
    line="${line}%{F${activeBg}}"
    line="${line}  $space  "
    first=false
    line="${line}%{F-}"
  fi
  echo $line
  sleep 0.1
done | lemonbar -b -f "Roboto:size=9" -g x"$panel_height" -B "$inactiveBG" -F "#$normalFg" -a "30" | zsh
