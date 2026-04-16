#!/usr/bin/env bash

# Execute all arguments as single command on every server in /vagrant/servers
# Executes provided command as the user executing the script
# Uses "ssh -o ConnectTimeout=2" to connect to a host
# Allows user to specify the following options
# 	-f FILE 	This allows the user to overrise the default file
# 	-n		This allows the user to perform a dry run
# 			Precede each command with "DRY RUN: "
# 	-s		Run the command with sudo on the remote servers
# 	-v		Enable verbose mode which displays the name of the
# 			server the command is executed on
# Enforce the script is not run with superuser privileges
# Provides usage statement
# Informs the user the command was not able to be executed on remote host
# Exit with status of 0 or most recent non-zero status 

# Usage statement
usage () {
	read -r -d '' msg <<-EOF
		Usage: ${0##*/} [-nsv] [-f FILE] COMMAND
		Executes COMMAND as a single command on every server
		  -f FILE	Use FILE for servers. Default $server_file
		  -n		Dry run
		  -s		Run with sudo on remote servers
		  -v		Verbose
EOF
	printf '%s\n' "$msg" >&2
	exit 1
}

# Bail out
bail_out () {
	# Check exit code and exit with error if non-zero
	if [[ "$?" -ne 0 ]]; then
		echo "$*" >&2
		exit 1
	fi
}

server_file='/vagrant/servers'
ssh_options='-o ConnectTimeout=2'

# Check user is not root otherwise exit with error
if [[ "$UID" -eq 0 ]]; then
	echo 'Must not be run as root. Use -s option instead.' >&2
	exit 1
fi

# Configure options
while getopts f:nsv option; do
	case "$option" in
		f)
			server_file="${OPTARG}"
			;;
		n)
			dry_run='true'
			;;
		s)
			sudo='sudo'
			;;
		v)
			verbose='true'
			;;
		?)
			usage
	esac
done

# Remove options while leaving remaining arguments.
shift "$(( OPTIND - 1 ))"

# If the user doesn't supply at least one argument, print usage.
if [[ "$#" -lt 1 ]]; then
	usage
fi

# Anything that remains on the command line is treated as a single command
command="${@}"

# Make sure server_file exists
if [[ ! -e "$server_file" ]]; then
	echo "Cannot open $server_file." >&2
	exit 1
fi

exit_status='0'

for server in $(cat $server_file); do
	if [[ "$verbose" = 'true' ]]; then
		echo "$server"
	fi

	ssh_command="ssh $ssh_options $server $sudo $command"

	# If it's a dry run, don't execute, just echo
	if [[ "$dry_run" = 'true' ]]; then
		echo "DRY RUN: $ssh_command"
	else
		$ssh_command
		ssh_exit_status="$?"

		# Capture any non-zero exit statuses
		if [[ "$ssh_exit_status" -ne 0 ]]; then
			exit_status="$ssh_exit_status"
			echo "Execution on $server failed." >&2
		fi
	fi
done

exit $exit_status
