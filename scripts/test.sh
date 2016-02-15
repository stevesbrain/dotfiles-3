wm_infos=$(i3-msg -t get_workspaces)
workspaces=$(echo $wm_infos | jq '. | length')
wm_output=""
last_screen=""
for ((i=0; i < $workspaces; i++))
do
  name=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].name')
  focused=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].focused')
  urgent=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].urgent')
  output=$(echo $wm_infos | jq -r --arg i "$i" '.[$i | tonumber].output')
  if [ "$output" = "HDMI1" ]; then
    if [ "$last_screen" != "0" ]; then
      wm_output="$wm_output%{Sf}"
    fi
    last_screen=0
  else
    if [ "$last_screen" = "0" ]; then
      wm_output="$wm_output%{Sl}"
    fi
    echo "$last_screen"
    last_screen=1
  fi
  if [ "$urgent" = "true" ]; then
    wm_output="$wm_output${name}"
  elif [ "$focused" = "true" ]; then
    wm_output="$wm_output${name}"
  else
    wm_output="$wm_output${name}"
  fi
done
if [ "$last_screen" != "0" ]; then
  wm_output="$wm_output%{Sf}"
fi
echo "W$wm_output"
