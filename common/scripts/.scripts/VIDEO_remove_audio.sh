#!/bin/bash

##
## RUN: "script dir"
##

# Check if a directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

TARGET_DIR="$1"

# Check if the provided directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' not found."
  exit 1
fi

echo "Processing .mp4 files in: $TARGET_DIR"

# Loop through every .mp4 file in the given directory
for input_file in "$TARGET_DIR"/*.mp4; do
  # Check if any .mp4 files were found to prevent error if none exist
  if [ -e "$input_file" ]; then
    filename=$(basename -- "$input_file")
    extension="${filename##*.}"
    filename_no_ext="${filename%.*}"
    output_file="${TARGET_DIR}/${filename_no_ext}_no_audio.mp4"

    echo "Processing: $input_file"
    echo "Outputting to: $output_file"

    # Execute the ffmpeg command
    ffmpeg -i "$input_file" -c:v copy -an "$output_file"

    if [ $? -eq 0 ]; then
      echo "Successfully processed $input_file"
    else
      echo "Error processing $input_file"
    fi
    echo "---"
  fi
done

echo "All .mp4 files processed."
