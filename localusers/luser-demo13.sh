#!/usr/bin/env bash

# This script shows the open network ports on a system.
# Use -4 as an argument to limit to TCPv4 ports.

netstat -nutl $1 | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
