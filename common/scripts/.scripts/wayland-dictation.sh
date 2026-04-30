#!/bin/bash

PID_FILE="/tmp/dictation.pid"
WAV_FILE="/tmp/dictation.wav"
MODEL="$HOME/.local/share/whisper/ggml-small.bin"

if [ -f "$PID_FILE" ]; then
    # Stop recording
    kill $(cat "$PID_FILE")
    rm "$PID_FILE"
    notify-send "⚙️ Dictation" "Processing..." -t 1000 -h string:x-canonical-private-synchronous:dictation

    # Transcribe the audio using the correct whisper-cli binary
    TEXT=$(whisper-cli -m "$MODEL" -f "$WAV_FILE" -nt 2>/dev/null | tr -d '\n' | sed 's/^[ \t]*//')

    # Type it out if text was found
    if [ -n "$TEXT" ]; then
        wtype "$TEXT "
    else
        notify-send "❌ Dictation" "Could not hear anything." -t 1500 -h string:x-canonical-private-synchronous:dictation
    fi

    # Clean up the audio file
    rm -f "$WAV_FILE"
else
    # Start recording using PipeWire for perfect hardware compatibility
    pw-record --rate=16000 --channels=1 --format=s16 "$WAV_FILE" &
    echo $! > "$PID_FILE"
    notify-send "🎙️ Dictation" "Listening... Press again to stop." -t 0 -h string:x-canonical-private-synchronous:dictation
fi
