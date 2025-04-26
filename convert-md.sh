#!/bin/bash

# Function to display help message
show_help() {
  cat << EOF
Usage: $0 [--recursive | -r | -R] [--delete-md | -d | -D] <folder_path>

This script processes all .md files to .md2 in the specified folder
by calling the process-md.sh script on each of them. Optionally, it can
also process files in subfolders recursively and delete the original .md files.

Options:
  --recursive, -r, -R   Process files in subfolders recursively.
  --delete-md, -d, -D   Delete the original .md files after conversion.

Parameters:
  <folder_path>   Path to the folder containing Markdown files.

Example:
  $0 /path/to/folder
  $0 --recursive /path/to/folder
  $0 -r /path/to/folder
  $0 -R /path/to/folder
  $0 --delete-md /path/to/folder
  $0 -d /path/to/folder
  $0 -D /path/to/folder

EOF
}

# Function to process .md files in a given folder
process_folder() {
  local path="${1%/}"
  
  # Process .md files in the current folder
  for md_file in "$path"/*.md; do
    if [ -f "$md_file" ]; then
      ./process-md.sh "$md_file"
      if [ "$delete_md" = true ]; then
        rm "$md_file"
      fi
    fi
  done

  # Recursively process subfolders if the recursive option is set
  if [ "$recursive" = true ]; then
    for subfolder in "$path"/*; do
      [ -d "$subfolder" ] && process_folder "$subfolder"
    done
  fi
}

main() {
  # Check if the --help option is provided
  if [ "$1" = "--help" ]; then
    show_help
    exit 0
  fi

  recursive=false
  delete_md=false

  # Check for flags
  while [ "$1" = "--recursive" ] || [ "$1" = "-r" ] || [ "$1" = "-R" ] || [ "$1" = "--delete-md" ] || [ "$1" = "-d" ] || [ "$1" = "-D" ]; do
    case "$1" in
      --recursive|-r|-R)
        recursive=true
        ;;
      --delete-md|-d|-D)
        delete_md=true
        ;;
    esac
    shift
  done

  # Check if the folder path is provided
  if [ -z "$1" ]; then
    echo "Error: Folder path not provided. Use --help for usage information."
    exit 1
  fi

  folder_path="$1"

  # Check if the folder exists
  if [ ! -d "$folder_path" ]; then
    echo "Error: Folder '$folder_path' not found. Use --help for usage information."
    exit 1
  fi

  # Start processing from the specified folder
  process_folder "$folder_path"

  echo "Processing completed for all .md files in $folder_path"
}

main "$@"
