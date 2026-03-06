#!/usr/bin/env bash

# Demonstrate the use of shift and while loops

# Display the first three parameters.
echo "Parameter 1: $1"
echo "Parameter 2: $2"
echo "Parameter 3: $3"
echo

# Loop through all the positional parameters.
echo "Username is: $1"
shift
echo "Remaining parameters are comment: $*"
