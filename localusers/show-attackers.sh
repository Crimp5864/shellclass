#!/usr/bin/env bash

# Requires file provided as argument. If not provided or cannot be read, exit with error status 1
# Count number of failed logins by IP. If any IP fails more than 10 times, display number of attemps,
# foreign IP, and location will be displayed
# Produce output in CSV with header of 'Count,IP,Location'.

# Assign first argument to variable
file=$1

# Check that file exists or exit with error
if [[ ! -e "$1" ]]; then
	echo 'File not provided or cannot be read.' >&2
	exit 1
fi

