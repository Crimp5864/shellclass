#!/usr/bin/env bash

# Must be executed as root. If not executed as root must exit immediately with status 1.
# Take username and full name (comment) as arguments on the command line.
# Provide usage statement if username is not provided as an argument.
# Use first argument as the username and any remaining arguments as the comment.
# Automatically generate a unique password.
# Create a user on the local system with provided input.
# Inform script runner if script was unable to create user for some reason and exits 1.
# Display username, password, and host where account was created.

# Check if user is root and exit if not
if [[ "$UID" -ne 0 ]]; then
	echo 'Must be root'
	exit 1
fi

# Provide usage statement if no username supplied
if [[ "$#" -lt 1 ]]; then
	echo "Usage: $(basename $0) USERNAME [COMMENT]"
	exit 1
fi

# Take username and full name as arguments
username="$1"
shift
if [[ -n "$*" ]]; then
	fullname="$*"
fi

# Automatically generate unique password
password=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c 16)

# Create user
useradd --comment "$fullname" --create-home "$username"

# Check if useradd succeeded
if [[ $? -ne 0 ]]; then
	echo 'Account creation failed'
	exit 1
fi

# Create password
passwd --stdin "$username" <<< "$password"

# Check if passwd succeeded
if [[ $? -ne 0 ]]; then
	echo 'Password creation failed'
	exit 1
fi

# Require password be changed on first login
passwd -e "$username"

if [[ $? -ne 0 ]]; then
	echo 'Account expiration failed'
	exit 1
fi

# Display username, password, and host
cat <<-EOF
	---
	username:
	$username

	password:
	$password

	host:
	$HOSTNAME
	---
EOF

exit 0
