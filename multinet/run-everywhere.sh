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
