#!/usr/bin/env bash

# This script generates a random password for each user specified on the command line.

# Display what the user typed on the command line.
echo "You executed this command: $0"

# Display the path and filename of the script.
echo "You used $(dirname $0) as the path to the $(basename $0) script."

# Tell the user how many arguments they passed in.
# (Inside the script they are parameters, outside they are arguments.)
number_of_parameters="$#"
echo "You supplied $number_of_parameters argument(s) on the command line."

# Make sure at least one argument is supplied.
if [[ "$number_of_parameters" -lt 1 ]]; then
	echo "Usage: $(basename $0) USER_NAME [USER_NAME]..."
	exit 1
fi

# Generate and display a password for each parameter.
for username in "$@"; do
	password=$(date +%s%N | sha256sum | head -c 48)
	echo "$username: $password"
done
