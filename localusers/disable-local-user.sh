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
		Usage: ${0##*/} [-adr] USERNAME [USERNAME]
		Disable account for USERNAME
		  -a	Archive home directory
		  -d	Delete account
		  -r 	Remove home directory
EOF
	printf '%s\n' "$msg" >&2
	exit 1
}

bail_out () {
	# Check exit code and exit with error if non-zero
	if [[ "$?" -ne 0 ]]; then
		echo "$*" >&2
		exit 1
	fi
}

archive_dir='/archive'

# Check if user is root and exit with error if not
if [[ "$UID" -ne 0 ]]; then
	echo 'Must be root' >&2
	exit 1
fi

while getopts adr option; do
	case "$option" in
		a)
			archive_home='true'
			;;
		d)
			delete_user='true'
			;;
		r)
			remove_home='-r'
			;;
		?)
			usage
			;;
	esac
done

# Remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

# If no arguments are provided print usage and exit with error
if [[ "$#" -lt 1 ]]; then
	usage
fi

# Loop through all the usernames supplied as arguments
for username in "$@"; do
	echo "Processing user: $username"
	
	# Make sure UID is at least 1000
	userid=$(id -u $username)
	if [[ "$userid" -lt 1000 ]]; then
		echo "Refusing to remove $username account with UID $uiserid" >&2
		exit 1
	fi

	# Create an archive if requested to do so
	if [[ "$archive_home" = 'true' ]]; then
		# Make sure archive_dir directory exists
		if [[ ! -d "$archive_dir" ]]; then
			echo "Creating $archive_dir directory"
			mkdir -p "$archive_dir"
			bail_out "The archive directory $archive_dir could not be created"
		fi

		# Archive the user's home directory and move it to archive_dir
		home_dir="/home/$username"
		archive_file="$archive_dir/$username.tgz"
		if [[ -d "$home_dir" ]]; then
			echo "Archiving $home_dir to $archive_file"
			tar -zcf $archive_file $home_dir &> /dev/null
			bail_out "Could not create $archive_file"
		else
			echo "$home_dir does not exist or is not a directory" >&2
			exit 1
		fi

	fi

	# Delete account if requested to do so
	if [[ "$delete_user" = 'true' ]]; then
		# Delete user
		userdel $remove_home "$username" &> /dev/null

		# Check to see if userdel succeeded
		bail_out "Unable to delete account $username"
		echo "The account $username was deleted"
	else
		chage -E 0 "$username"

		# Check to see if chage succeeded
		bail_out "Unable to disable account $username"
		echo "The account $username was disabled"
	fi
done

exit 0
