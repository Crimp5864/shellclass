#!/usr/bin/env bash

log () {
	# This function sends a message to syslog and to standard output if verbose is true.
	local message="$*"

	if [[ "$verbose" = 'true' ]]; then
		echo "$message"
	fi

	logger -t $(basename "$0") "$message"
}

backup_file () {
	# This function creates a backup of a file. Returns non-zer status on error.

	local file="$1"

	# Make sure file exists.
	if [[ -f "$file" ]]; then
		local backup_file="/var/tmp/$(basename "$file").$(date +%F-%N)"
		log "Backing up $file to $backup_file."

		# The exit status of the function will be the exit status of the cp command.
		cp -p "$file" "$backup_file"
	else
		# The file does not exist, so return a non-zero exit status.
		return 1
	fi
}

readonly verbose='true'
log 'Hello!'
log 'This is fun!'

backup_file '/etc/passwd'

# Make a decision based on the exit status of the function
if [[ "$?" -eq '0' ]]; then
	log 'File backup succeeded!'
else
	log 'File backup failed!'
	exit 1
fi
