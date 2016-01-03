#! /bin/bash

padding="    "

spaceicon() {
  echo -e "\uf$(echo "obase=16;ibase=16;452+$1*3+$2" | bc)"
}

taskicon() {
  tree=$(bspc query -T --desktop $name)

  case $tree in
    *"streaming_client"*)
      echo -e "%{T5}\uf35e%{T1}"
      ;;
    *"Atom"*)
      echo -e "%{T5}\uf246%{T1}"
      ;;
    *"Steam"*)
      echo -e "%{T4}\uf35e%{T1}"
      ;;
    *"Discord"*)
      echo -e "%{T5}\uf419%{T1}"
      ;;
    *"Firefox"*)
      echo -e "%{T5}\uf61c%{T1}"
      ;;
    *"Gnome-terminal"*)
      echo -e "%{T5}\uf25e%{T1}"
      ;;
    *)
      echo "$(spaceicon $name 0)"
      ;;
  esac
}

while read -r line ; do

  case $line in
    A* )
      title=$(xprop -id ${line#?} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2 | awk -v len=100 '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }')
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
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{U#FFFFFF}%{+u}$padding$(spaceicon $name 2)$padding%{-u}%{A}"
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
            workspace_string="${!wm_var}%{A:bspc desktop -f ${name}:}%{F#AAFFFFFF}$padding$(spaceicon $name 2)$padding%{F-}%{A}"
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
        network="   %{T5}\uf3d0   "
      else
        network="   %{T5}\uf3d0   "
      fi
      ;;
  esac

  echo -e "%{c}$monitor_1$monitor_2%{r}  $clock   $updates$volume$network$redshift_status   "

done
