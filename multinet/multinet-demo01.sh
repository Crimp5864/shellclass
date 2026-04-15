#!/usr/bin/env bash

# This script pings a list of servers and reports their status.

server_file='/vagrant/servers'

if [[ ! -e "$server_file" ]]; then
	echo "Cannot open $server_file." >&2
	exit 1
fi

for server in $(cat "$server_file"); do
	echo "Pinging $server"
	ping -c 1 "$server" &> /dev/null
	if [[ "$?" -ne 0 ]]; then
		echo "$server down."
	else
		echo "$server up."
	fi
done

