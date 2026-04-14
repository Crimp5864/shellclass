#!/usr/bin/env bash

# Requires file provided as argument. If not provided or cannot be read, exit with error status 1
# Count number of failed logins by IP. If any IP fails more than 10 times, display number of attemps,
# foreign IP, and location will be displayed
# Produce output in CSV with header of 'Count,IP,Location'.

# Assign first argument to variable
log_file="$1"
limit='10'

# Check that file exists or exit with error
if [[ ! -e "$1" ]]; then
	echo "Cannot open log file: $log_file" >&2
	exit 1
fi

# Produce CSV output with headers 'Count,IP,Location'
echo 'Count,IP,Location'

# Loop through list of failed logins and IPs
grep Failed syslog-sample | awk '{print $(NF - 3)}' | \
       	sort | uniq -c | sort -nr | \
	while read count ip; do
		# If the number of attempts is greater than the limit
		# display count, IP, and location.
		if [[ "$count" -gt "$limit" ]]; then
			location=$(geoiplookup $ip | awk -F ', ' '{print $2}')
			echo "$count,$ip,$location"
		fi
	done
	exit 0


# List IPs that fail more than 10 times

# For each IP list number of attempts made, IP, and location


