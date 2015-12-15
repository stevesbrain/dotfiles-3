#! /bin/bash

padding="    "

taskicon() {
  tree=$(bspc query -T --desktop $name)

  if [[ $tree == *"Atom"* ]]; then
    echo -e "%{T5}\uf246%{T1}"
  elif [[ $tree == *"Steam"* ]]; then
    echo -e "%{T4}\uf35e%{T1}"
  elif [[ $tree == *"Discord"* ]]; then
    echo -e "%{T5}\uf419%{T1}"
  elif [[ $tree == *"0x3600001"* ]]; then
    echo -e "%{T5}\uf38a%{T1}"
  elif [[ $tree == *"Firefox"* ]]; then
    echo -e "%{T5}\uf61c%{T1}"
  elif [[ $tree == *"Gnome-terminal"* ]]; then
    echo -e "%{T5}\uf25e%{T1}"
  else
    echo $name
  fi
}

while read -r line ; do

  case $line in
    A* )
      title=$(xprop -id ${line#?} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      ;;
    W* )
      # bspwm internal state
      monitor_1="%{Sf}"
      monitor_2="%{Sl}"
      IFS=':'
      set -- ${line#?}
      while [ $# -gt 0 ] ; do
        item=$1
        name=${item#?}
        case $item in
          *HDMI1)
            wm_var=monitor_1
            ;;
          *VGA1)
            wm_var=monitor_2
            ;;
          O*)
            # focused occupied desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{U#FFFFFF}%{+u}$padding$(taskicon)$padding%{-u}%{A}"
            eval $wm_var=\$workspace_string
            ;;
          F*)
            # focused free desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{U#FFFFFF}%{+u}$padding${name}$padding%{-u}%{A}"
            eval $wm_var=\$workspace_string
            ;;
          U*)
            # focused urgent desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{U#FFFFFF}%{+u}$padding$(taskicon)$padding%{-u}%{A}"
            eval $wm_var=\$workspace_string
            ;;
          o*)
            # occupied desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}$padding$(taskicon)$padding%{A}"
            eval $wm_var=\$workspace_string
            ;;
          f*)
            # free desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{F#AAFFFFFF}$padding${name}$padding%{F-}%{A}"
            eval $wm_var=\$workspace_string
            ;;
          u*)
            # urgent desktop
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}$padding$(taskicon)$padding%{A}"
            eval $wm_var=\$workspace_string
            ;;
        esac
        shift
      done
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
        network="   %{T5}\uf3d0 %{T3}$megabytes Mb/s"
      else
        network="   %{T5}\uf3d0 %{T3}$kilobytes Kb/s"
      fi
      ;;
  esac

  echo -e "$monitor_2$monitor_1    $title%{c}$clock%{r}$updates$volume$network  $load$redshift_status  "

done
