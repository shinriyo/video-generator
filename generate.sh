#!/usr/bin/env bash
set -euo pipefail

font_ja="./fonts/NotoSansCJKjp-Regular.otf"   # ← adjust if you changed the path
font_tr="./fonts/NotoSans-Regular.ttf"

mkdir -p clips

# -- read TSV, strip CR, generate clips ---------------------------------------
tr -d '\r' < lines.tsv | \
while IFS=$'\t' read -r id ja tr || [[ -n "$id" ]]; do
  [[ -z "$id" ]] && continue   # skip blank lines

  audio=$(printf "%02d.mp3" "$id")           # 01.mp3 …
  clip="clips/$(printf "%02d.mp4" "$id")"    # clips/01.mp4 …

  # escape single quotes so drawtext doesn't break
  ja_esc=${ja//\'/\\\'}
  tr_esc=${tr//\'/\\\'}

  ffmpeg -v error -y \
    -f lavfi -i "color=c=black:s=1280x720:d=3" \
    -i "$audio" \
    -vf "[0:v]drawtext=fontfile=${font_ja}:text='${ja_esc}':\
                     fontcolor=white:fontsize=60:x=(w-text_w)/2:y=(h/2)-80,\
         drawtext=fontfile=${font_tr}:text='${tr_esc}':\
                     fontcolor=white:fontsize=60:x=(w-text_w)/2:y=(h/2)+20" \
    -c:v libx264 -pix_fmt yuv420p \
    -c:a aac \
    -shortest "$clip"
done

# -- build concat list --------------------------------------------------------
ls -1v clips/*.mp4 | while read -r f; do
  echo "file '$PWD/$f'"
done > list.txt

# -- concatenate without re‑encoding -----------------------------------------
ffmpeg -v error -f concat -safe 0 -i list.txt -c copy all.mp4

# -- optional cleanup ---------------------------------------------------------
rm -r clips list.txt
echo "✓  Finished: all.mp4 was created"

