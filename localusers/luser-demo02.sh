#!/usr/bin/env bash

# Display the UID and username of the user executing thie script.
# Display if the user is the root user or not.

# Display the UID
echo "Your UID is $UID"

# Display the username
username=$(id -un)
echo "Your username is $username"

# Display if the user is the root user or not
if [[ "$UID" -eq 0 ]]; then
	echo 'You are root.'
else
	echo 'You are not root.'
fi
