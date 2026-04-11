#!/usr/bin/env bash

# Enforce execution as root or exit with error.
# Provide a usage statement if no account name supplied and exit with error.
# Default behavior should disable account.
# Allow the following options:
#	-d Deletes account instead of disabling.
#	-r Removes the home directory.
#	-a Creates an archive of the home directory and stores it in the /archives directory.
#	Any other options should display usage and exit with error.
# Accept list of usernames as arguments. At least one is required.
# Refuse to disable or delete any account lower than 1000 UID.
#	Only allow help desk to change user accounts, not system accounts.
# Inform the user if account was not able to be disabled, deleted, or archived.
# Display uername and any actions performed against the account.

usage () {
	# Print usage and exit with error.
	read -r -d '' msg <<-EOF
		Usage: ${0##*/} [-adr] USERNAME
		Disable account for USERNAME
		  -a	Archive home directory
		  -d	Delete account
		  -r 	Remove home directory
EOF
	printf '%s\n' "$msg" >&2
	exit 1
}

# Check if user is root and exit if not
if [[ "$UID" -ne 0 ]]; then
	echo 'Must be root' >&2
	exit 1
fi

# Disable user
userdel $1 #&> /dev/null
exit 1

# Check if useradd succeeded
if [[ $? -ne 0 ]]; then
	echo 'Account creation failed' >&2
	exit 1
fi

# Create password
passwd --stdin "$username" <<< "$password" &> /dev/null

# Check if passwd succeeded
if [[ $? -ne 0 ]]; then
	echo 'Password creation failed' >&2
	exit 1
fi

# Require password be changed on first login
passwd -e "$username" &> /dev/null

if [[ $? -ne 0 ]]; then
	echo 'Account expiration failed' >&2
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
