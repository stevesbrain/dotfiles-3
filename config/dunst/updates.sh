#!/usr/bin/env bash

echo "$(echo "$3" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | sed 's/-> //g')"

zenity --title="Updates verfügbar" --width=488 --height=640 --list --separator=" " --text="Folgende Updates werden installiert:" --column="Paket" --column="installierte Version" --column="aktuellste Version" $(echo "$3" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' | sed 's/-> //g') && gnome-terminal -e "sudo pacman -Syu"
