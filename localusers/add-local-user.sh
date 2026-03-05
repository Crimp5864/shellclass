#!/usr/bin/env bash

# Must be executed as root. If not executed as root must exit immediately with status 1.
# Prompt script runner to enter username, full name of user, and initial password.
# Create a user on the local system with provided input.
# Inform script runner if script was unable to create user for some reason and exits 1.
# Display username, password, and host where account was created.

# Check if user is root and exit if not
if [[ "$UID" -ne 0 ]]; then
	echo 'Must be root'
	exit 1
fi

# Get username
read -p 'Enter desired username: ' username

# Get full name
read -p 'Enter full name of user: ' fullname

# Get password
read -p 'Enter initial password: ' password

# Create user
useradd -c "$fullname" -m "$username"

# Check if useradd succeeded
if [[ $? -ne 0 ]]; then
	echo 'Account creation failed'
	exit 1
fi

# Create password
#echo "$password" | passwd --stdin "$username"
passwd --stdin "$username" <<< "$password"

# Check if passwd succeeded
if [[ $? -ne 0 ]]; then
	echo 'Password creation failed'
	exit 1
fi

# Require password be changed on first login
passwd -e "$username"

# Display username, password, and host
cat <<-EOF

	username:
	$username

	password:
	$password

	host:
	$HOSTNAME
EOF

exit 0
