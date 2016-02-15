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
    N* )
      kilobytes=$(echo "scale=0; (${line#?}-${allbytes:-0})/1024" | bc -l)
      allbytes="${line#?}"
      if [ $kilobytes -ge 1024 ]; then
        megabytes=$(echo "scale=2; ${kilobytes}/1024" | bc -l)
        network="    %{T4}\uf2e8 %{T3}$megabytes Mb/s"
      else
        network="    \uf2e8 $kilobytes Kb/s"
      fi
      ;;
  esac

  echo -e "%{l}$wm_infos    $title%{c}$clock%{r}$updates$volume$network$load$redshift_status  "

done
