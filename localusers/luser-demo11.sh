#!/usr/bin/env bash

# This script generates a random password.
# The user can set the password length with -l and add a special character with -s.
# Verbose mode can be enabled with -v.

usage () {
	# Print usage and exit with error.
	read -r -d '' msg <<-EOF
		Usage: ${0##*/} [-vs] [-l LENGTH]
		Generate a random password
		  -l LENGTH Specify the password length.
		  -s	    Append a special character to the password.
		  -v	    Increase verbosity.
EOF
	printf '%s\n' "$msg" >&2
	exit 1
}

log () {
	# Print verbose messages to screen.
	local message="$*"
	if [[ "$verbose" = 'true' ]]; then
		echo "$message" 
	fi
}

# Set a default password length.
length=48

while getopts vl:s option; do
	case "$option" in
		v)
			verbose='true'
			log 'Verbose mode on.'
			;;
		l)
			length="$OPTARG"
			;;
		s)
			use_special_character='true'
			;;
		?)
			usage
			;;
	esac
done

log 'Generating a password.'

password=$(date +%s%N$RANDOM$RANDOM | sha256sum | head --bytes="$length")

# Append a special character if requested to do so.
if [[ "$use_special_character" = 'true' ]]; then
	log 'Selecting a random special character.'
	special_character=$(echo '!@#$%^&*()_-+=' | fold --width=1 | shuf | head --bytes=1)
	password="$password$special_character"
fi

log 'Done.'
log 'Here is the password:'

# Display the password.
echo "$password"

exit 0
