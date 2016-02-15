# Created by newuser for 5.1.1
eval "$(fasd --init auto)"

NOTIFY_COMMAND_COMPLETE_TIMEOUT=30

source /usr/share/zsh/plugins/zsh-notify/notify.plugin.zsh

export EDITOR=nano

alias feh='feh --scale-down --auto-zoom'
alias t='todo.sh'

alias pi='ssh pi@192.168.0.22'

autoload -Uz promptinit
promptinit
prompt pure

# set an ad-hoc timer
timer() {
  local N=$1; shift

  (sleep $N && notify-send -u critical -i /usr/share/icons/Faba/48x48/categories/preferences-system-time.png "Wecker" "$@" && beep -l 50 -r 4 ) &
  echo "alarm set for $N"
}

alarm() {
  local N=$1; shift

  (sleep $(( $(date --date="$N" +%s) - $(date +%s) )) && notify-send -u critical -i /usr/share/icons/Faba/48x48/categories/preferences-system-time.png "Timer" "$@" && beep -l 50 -r 4 ) &
  echo "timer set for $N"
}

za() {
  atom $(fasd -f "$@")
}

export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=" -R "
