#!/usr/bin/env bash

# This script creates an account on the local system.
# You will be prompted for the account name and password.

# Ask for the user name.
read -p 'Enter the username to create: ' username

# Ask for the real name.
read -p 'Enter the name of the person who this account is for: ' comment

# Ask for the password.
read -p 'Enter the password to use for the account: ' password

# Create the user.
useradd -c "$comment" -m $username

# Set password for the user.
echo $password | passwd --stdin $username

# Force password change on first login.
passwd -e $username
