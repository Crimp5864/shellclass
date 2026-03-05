#!/usr/bin/env bash

# This script generates a list of random passwords.

# A random numbe as a password.
password="$RANDOM"
echo "$password"

# Three random numbers together.
password="${RANDOM}${RANDOM}${RANDOM}"
echo "$password"

# Use the current date/time as the basis for the password.
password=$(date +%s)
echo "$password"

# User nanoseconds to act as randomization.
password=$(date +%s%N)
echo "$password"

# A better password.
password=$(date +%s%N | sha256sum | head -c 32)
echo "$password"

# An even better password.
password=$(date +%s%N%{RANDOM}${RANDOM} | sha256sum | head -c 48)
echo "$password"

# Append a special character to the password.
special=$(echo '!@#$%^&*()_-+=' | fold -w 1 | shuf | head -c 1)
echo "${password}${special}"
