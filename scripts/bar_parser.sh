#! /bin/sh
while read -r line ; do

  case $line in
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
  esac

  printf "%s\n" "%{l}$wm_infos%{c}$clock%{r}$volume$load$redshift_status"

done
