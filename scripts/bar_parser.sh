#! /bin/sh
while read -r line ; do

  case $line in
    A* )
      title=$(xprop -id ${line#?} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      ;;
    W* )
      wm_infos="${line#?}"
      ;;
    C* )
      clock="${line#?}"
      ;;
    R* )
      redshift_status="${line#?}"
      ;;
    V* )
      volume="${line#?}"
      ;;
    L* )
      load="${line#?}"
      ;;
    U* )
      updates="${line#?}"
      ;;
  esac

  printf "%s\n" "%{l}$wm_infos    $title%{c}$clock%{r}$updates$volume$load$redshift_status"

done
