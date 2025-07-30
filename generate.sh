#!/usr/bin/env bash
#font_ja="/path/to/NotoSansCJKjp-Regular.otf"
font_ja="NotoSansCJKjp-Regular.otf"
#font_tr="/path/to/NotoSans-Regular.ttf"
font_tr="NotoSans-Regular.ttf"

while IFS=$'\t' read -r id ja tr; do
  audio=$(printf "%02d.mp3" "$id")
  #audio=$(printf "%02d.wav" "$id")
  out=$(printf "%02d.mp4" "$id")

  ffmpeg -y \
    -f lavfi -i "color=c=black:s=1280x720:d=3" \
    -i "$audio" \
    -vf "[0:v]drawtext=fontfile=${font_ja}:text='${ja}':\
                  fontcolor=white:fontsize=60:x=(w-text_w)/2:y=(h/2)-80,\
         drawtext=fontfile=${font_tr}:text='${tr}':\
                  fontcolor=white:fontsize=60:x=(w-text_w)/2:y=(h/2)+20" \
    -c:v libx264 -pix_fmt yuv420p -c:a aac -shortest "$out"
done < lines.tsv

