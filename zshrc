# Created by newuser for 5.1.1
eval "$(fasd --init auto)"

export EDITOR=nano

alias feh='feh --scale-down --auto-zoom'
alias t='todo.sh'

autoload -Uz promptinit
promptinit
prompt pure

# set an ad-hoc GUI timer
timer() {
  local N=$1; shift

  (sleep $N && zenity --info --title="Time's Up" --text="${*:-BING}") &
  echo "timer set for $N"
}

za() {
  atom $(fasd -f "$@")
}
