#!/bin/bash

show_help() {
  cat << EOF
Usage: $0 [--recursive | -r | -R] <path>

This script processes all .md2 files in the specified folder or the specified file and formats HTML tags to be on separate lines.

Options:
  --recursive, -r, -R   Process files in subfolders recursively (only applicable for directories).

Parameters:
  <path>   Path to the folder or file containing Markdown files.

Example:
  $0 /path/to/folder
  $0 /path/to/folder/file.md2
  $0 --recursive /path/to/folder
  $0 -r /path/to/folder
  $0 -R /path/to/folder

EOF
}

format_html_tags() {
  if [ "${1##*.}" != "md2" ]; then
    echo "Error: File '$1' is not an .md2 file."
    return 1
  fi

  awk '
  {
    # Preserve empty lines
    if ($0 ~ /^$/) {
      print ""
      next
    }

    # Process lines containing HTML tags
    while (match($0, /<[^>]+>/)) {
      pre = substr($0, 1, RSTART-1)
      tag = substr($0, RSTART, RLENGTH)
      post = substr($0, RSTART+RLENGTH)
      if (pre != "") print pre
      print tag
      $0 = post
    }
    
    # If there is remaining content after the last tag, print it
    if ($0 != "") print $0
  }' "$1" > "${1}.tmp"

  if ! cmp -s "$1" "${1}.tmp"; then
    mv "${1}.tmp" "$1"
    echo "HTML formatting completed for $1"
  else
    rm "${1}.tmp"
  fi
}

process_folder() {
  for file in "$1"/*.md2; do
    [ -f "$file" ] && format_html_tags "$file"
  done
  [ "$recursive" = true ] && for dir in "$1"/*/; do
    [ -d "$dir" ] && process_folder "$dir"
  done
}

main() {
  [ "$1" = "--help" ] && show_help && exit 0
  recursive=false
  while [ "$1" = "--recursive" ] || [ "$1" = "-r" ] || [ "$1" = "-R" ]; do
    recursive=true; shift
  done
  [ -z "$1" ] && echo "Error: Path not provided. Use --help for usage information." && exit 1
  if [ -d "$1" ]; then
    process_folder "$1"
    echo "HTML formatting completed for all .md2 files in $1"
  elif [ -f "$1" ]; then
    if [ "${1##*.}" = "md2" ]; then
      format_html_tags "$1"
    else
      echo "Error: File '$1' is not an .md2 file."
      exit 1
    fi
  else
    echo "Error: Path '$1' not found. Use --help for usage information." && exit 1
  fi
}

main "$@"
