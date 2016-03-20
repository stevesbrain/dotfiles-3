#!/bin/sh

cover_location="/tmp/spotify-cover"
dunstify_id="/tmp/spotify-notify_dunstify_id"

title=$2
body=$3
artist=$(echo "$body" | sed -e 's/ - .*//' -e 's/\s/%20/g')
album=$(echo "$body" | sed -e 's/.* - //' -e 's/\s/%20/g')

# echo "https://api.spotify.com/v1/search?q=$album%20$artist&type=album"
# echo $(curl -X GET "https://api.spotify.com/v1/search?q=$album%20$artist&type=album")

url=$(curl -X GET "https://api.spotify.com/v1/search?q=$album%20$artist&type=album" | jq -r '.albums.items[0].images[-1].url')

curl -o $cover_location $url

convert $cover_location -resize 50% "${cover_location}.png"

[ ! -z "$(cat "$dunstify_id")" ] && id_arg="-r $(cat "$dunstify_id")"

dunstify \
  -a "ncmpcpp" \
  -i "${cover_location}.png" \
  "$title" \
  "$body" \
  -p $id_arg > "$dunstify_id"
