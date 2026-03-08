#!/usr/bin/env bash

# This script demonstrates I/O redirection.

# Redirect STDOUT to a file.
file="/tmp/data"
head -n 1 /etc/passwd > $file

# Redirect STDIN to a program.
read line < $file
echo "line contains: $line"

# Redirect STDOUT to a file, overwriting the file.
head -n 3 /etc/passwd > $file
echo 
echo "Contents of $file:"
cat $file

# Redirect STDOUT to a file, appenting to the file.
echo "$RANDOM $RANDOM" >> $file
echo "$RANDOM $RANDOM" >> $file
echo
echo "Contents of $file:"
cat $file

# Redirect STDIN to a program, using FD 0.
read line 0< $file
echo "line contains: $line"

# Redirect STDOUT to a file using FD 1, overwriting the file.
head -n 3 /etc/passwd 1> $file
echo
echo "Contents of $file:"
cat $file

# Redirect STDERR to a file using FD 2.
err_file="/tmp/data.err"
head -n 3 /etc/passwd /fakefile 2> $err_file

# Redirect STDOUT and STDERR to a file.
head -n 3 /etc/passwd /fakefile &> $file
echo
echo "Contents of $file:"
cat $file

# Redirect STDOUT and STDERR through a pipe.
echo
head -n 3 /etc/passwd /fakefile |& cat -n

# Send output to STERR
echo "This is STDERR!" >&2

# Discard STDOUT
echo
echo "Discarding STDOUT:"
head -n 3 /etc/passwd /fakefile > /dev/null

# Discard STDERR
echo
echo "Discarding STDERR:"
head -n 3 /etc/passwd /fakefile 2> /dev/null

# Discard STDOUT and STDERR
echo
echo "Discarding STDOUT and STDERR:"
head -n 3 /etc/passwd /fakefile &> /dev/null

# Clean up
rm $file $err_file &> /dev/null
