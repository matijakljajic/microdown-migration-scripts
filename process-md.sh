#!/bin/bash

# Function to display help message
show_help() {
  cat << EOF
Usage: $0 <input.md>

This script processes a .md file with specific metadata in the first three lines,
normalizes carriage returns, and converts the metadata into JSON format.
It then saves the original .md with JSON-formatted metadata into a .md2 file ready for Foliage.

Parameters:
  <input.md>   Input Markdown file containing metadata in the first three lines.

Example:
  $0 example.md

The input file should have the following metadata format in the first three lines:
  title: <title>
  layout: <layout>
  publishDate: <date>

EOF
}

# Function to extract and quote metadata if necessary
extract_and_quote() {
  local line_number=$1
  local prefix=$2
  local value=$(sed -n "${line_number}p" "$input_file" | sed "s/^${prefix}: *//")
  
  if [ "${value:0:1}" != "\"" ]; then
    value="\"$value\""
  fi
  
  echo "$value"
}

# Main function
main() {
  # Check if the --help option is provided
  if [ "$1" = "--help" ]; then
    show_help
    exit 0
  fi

  # Check if the input file is provided
  if [ -z "$1" ]; then
    echo "Error: Input file not provided. Use --help for usage information."
    exit 1
  fi

  input_file="$1"
  output_file="${input_file%.*}.md2"

  # Check if input file exists
  if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found. Use --help for usage information."
    exit 1
  fi

  # Normalize carriage returns for Unix
  sed 's/\r/\n/g' "$input_file" > "${input_file}.tmp" && mv "${input_file}.tmp" "$input_file"

  # Extract metadata and append Microdown
  title=$(extract_and_quote 1 "title")
  layout=$(extract_and_quote 2 "layout")
  publishDate=$(extract_and_quote 3 "publishDate")

  {
    echo "{"
    echo "\"title\": $title,"
    echo "\"layout\": $layout,"
    echo "\"publishDate\": $publishDate"
    echo "}"
  } > "$output_file"

  tail -n +4 "$input_file" >> "$output_file"

  echo "Conversion completed. Output saved to $output_file"
}

main "$@"
