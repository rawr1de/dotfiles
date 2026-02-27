#!/bin/bash

# Usage: ./format_lyrics.sh input.txt output.txt [line_count]
# line_count: number of blank lines between songs (default: 3)

if [ $# -lt 2 ]; then
    echo "Usage: $0 input.txt output.txt [line_count]"
    echo "  line_count: number of blank lines between songs (default: 3)"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"
BLANK_LINES="${3:-3}"

if [ ! -f "$INPUT" ]; then
    echo "Error: Input file '$INPUT' not found"
    exit 1
fi

# Clear output file
> "$OUTPUT"

song_num=0
in_lyrics=false
first_song=true

while IFS= read -r line || [ -n "$line" ]; do
    # Check if line starts with a number (song line)
    if [[ "$line" =~ ^[0-9]+\.[[:space:]] ]]; then
        # Extract song number and title
        song_num=$((song_num + 1))
        
        # Extract title (everything between the number and tab/time)
        title=$(echo "$line" | sed -E 's/^[0-9]+\.[[:space:]]+([^[:space:]]+.*?)[[:space:]]+[0-9]+:[0-9]+.*/\1/' | xargs)
        
        # Add blank lines before song (except first song)
        if [ "$first_song" = false ]; then
            for ((i=0; i<BLANK_LINES; i++)); do
                echo "" >> "$OUTPUT"
            done
        fi
        first_song=false
        
        # Write formatted song number and title
        printf "%02d.)  %s\n" "$song_num" "$title" >> "$OUTPUT"
        echo "" >> "$OUTPUT"
        
        in_lyrics=true
        continue
    fi
    
    # Skip "Hide lyrics" line
    if [[ "$line" =~ "Hide lyrics" ]]; then
        continue
    fi
    
    # If we're in lyrics section, write everything (including blank lines)
    if [ "$in_lyrics" = true ]; then
        # Remove leading whitespace but keep the line (even if empty)
        cleaned=$(echo "$line" | sed 's/^[[:space:]]*//')
        echo "$cleaned" >> "$OUTPUT"
    fi
done < "$INPUT"

echo "Formatted lyrics written to: $OUTPUT"