#!/usr/bin/env bash

# Display the UID and username of the user executing this script.
# Display if the user is the vagrant user or not.

# Display the UID.
echo "Your UID is $UID"

# Only display if the UID does NOT match 1000.
uid_to_test_for='1000'
if [[ "$UID" -ne "$uid_to_test_for" ]]; then
	echo "Your UID does not match $uid_to_test_for."
	exit 1
fi

# Display the username.
username="$(id -un)"

# Test if the command succeeded.
if [[ "$?" -ne 0 ]]; then
	echo 'The id command did not execute successfully.'
	exit 1
fi
echo "Your username is $username."

# You can use a string test conditional.
username_to_test_for='vagrant'
if [[ "$username" = "$username_to_test_for" ]]; then
	echo "Your username matches $username_to_test_for."
fi

# Test for != (not equal) for the string.
if [[ "$username" != "$username_to_test_for" ]]; then
	echo "Your username does not match $username_to_test_for."
	exit 1
fi

exit 0
