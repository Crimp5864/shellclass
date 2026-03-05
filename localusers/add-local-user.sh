#!/usr/bin/env bash

# Must be executed as root. If not executed as root must exit immediately with status 1.
# Prompt script runner to enter username, full name of user, and initial password.
# Create a user on the local system with provided input.
# Inform script runner if script was unable to create user for some reason and exits 1.
# Display username, password, and host where account was created.

# Get hostname

# Get UID

# Check if user is root and exit if not
if [[ "$UID" -ne 0 ]]; then
	echo 'Rerun as root'
	exit 1
fi

# Get username
read -p 'Enter desired username: ' username

# Get full name
read -p 'Enter full name of user: ' fullname

# Get password
read -p 'Enter initial password: ' password

# Create user
if ! $( adduser -c "$fullname" -m "$username" ); then
	echo 'User creation failed'
	exit 1
fi

# Create password
echo "$password" | passwd --stdin "$username"

# Require password be changed on first login
passwd -e "$username"

# Display username, password, and host
echo "Username created: $username"
echo "Initial password: $password"
echo "User created on: $HOSTNAME"
