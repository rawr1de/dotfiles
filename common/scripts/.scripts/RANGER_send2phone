#!/bin/bash
#
# Send files to phone.
# It's a wrapper around KDE Connect CLI to provide
# a bit more functionality.
#
# Copyright (C) 2019-2021 Rafael Cavalcanti <https://rafaelc.org/dev>
# Licensed under GPLv3

# https://rafaelc.org/posts/send-files-to-your-phone-from-file-manager/
# bind key command: map bp shell -f send2phone %s  (rc.conf [Ranger])
# send2phone > bp (within Ranger)

#
# !!! ONLY ONE DEVICE CAN BE PAIRED FOR IT TO WORK !!!
#

readonly script_name="$(basename "$0")"

if (( $# == 0 )); then
	printf "Usage: %s file [file...]\n" "$script_name"
	exit 1
fi

readonly phone_id="$(kdeconnect-cli -l --id-only | head -1)"

while (( $# > 0 )); do
	file="$1"
	base="$(basename -- "$file")"
	if kdeconnect-cli --device "$phone_id" --share "$file"; then
		notify-send --urgency=normal "$script_name" "File sent: $base"
	else
		notify-send --urgency=critical "$script_name" "Failed to send file: $base"
	fi
	shift
done
