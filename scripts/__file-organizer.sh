#!/bin/env bash

# Directory Organizer
# Usage: $0 [source-directory] [dest-directory]

dir1="$1"
dir2="$2"

function directory_check() {

  # Media

  [[ -d "$dir2/media/videos" ]] || mkdir -p "$dir2/media/videos"
  [[ -d "$dir2/media/gifs" ]] || mkdir -p "$dir2/media/gifs"
  [[ -d "$dir2/media/music" ]] || mkdir -p "$dir2/media/music"
  [[ -d "$dir2/media/images" ]] || mkdir -p "$dir2/media/images"

  # Documents

  [[ -d "$dir2/documents" ]] || mkdir -p "$dir2/documents"
  [[ -d "$dir2/pdf" ]] || mkdir -p "$dir2/pdf"
  [[ -d "$dir2/presentations" ]] || mkdir -p "$dir2/presentations"

  # Archives

  [[ -d "$dir2/archives" ]] || mkdir -p "$dir2/archives"

  # Others

  [[ -d "$dir2/others" ]] || mkdir -p "$dir2/others"
}

function organizer() {
  find "$dir1" -type f -exec bash -c '
      dir2="$1"
      dest_dir=""
      case "$0" in
          *.jpg|*.png|*.webp|*.jpeg|*.bmp|*.tiff|*.svg|*.raw|*.jpeg) dest_dir="$dir2/media/images/" ;;
          *.gif) dest_dir="$dir2/media/gifs/" ;;
          *.doc|*.docx|*.odt|*.epub|*.rtf) dest_dir="$dir2/documents/" ;;
          *.pdf) dest_dir="$dir2/pdf/" ;;
          *.ppt|*.potx|*.pptx) dest_dir="$dir2/presentations/" ;;
          *.zip|*.tar.gz|*.tar.xz) dest_dir="$dir2/archives/" ;;
          *.mp4|*.mov|*.mkv|*.avi|*.mpeg|*.m4a) dest_dir="$dir2/media/videos/" ;;
          *.mp3|*.ogg|*.aac|*.wav|*.flac|*.ape|*.aiff|*.pcm|*.opus) dest_dir="$dir2/media/music/" ;;
          *) dest_dir="$dir2/others/" ;;
      esac
      if [[ -e "$dest_dir$(basename "$0")" ]]; then
          echo "Skipping $0, already exists in $dir2."
      else
          mv "$0" "$dest_dir"
          echo "Moved $0 to $dest_dir"
      fi
  ' {} "$dir2" \;
  echo "Complete!"
}

directory_check
organizer
