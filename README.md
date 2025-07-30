# video-generator

Batch script that uses **FFmpeg** to create 1280×720 flash-card videos  
with Japanese + Turkish text and audio.

## Features

- Converts a TSV (`lines.tsv`) + matching MP3 files (`01.mp3`, `02.mp3`, …) into clips
- Auto-draws bilingual text with custom fonts
- Concatenates all clips into a single `all.mp4`
- Works on macOS / Linux / Windows (WSL) with FFmpeg pre-installed

## Usage

```bash
# 1. install ffmpeg & fonts, then
bash generate.sh
```

Generated video appears as all.mp4.

## License

MIT
