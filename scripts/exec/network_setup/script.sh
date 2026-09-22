#!/bin/sh
# Source: /reference/sandbox/utilities/exec/ — "Container Network Setup
# (Remote Mode - New Container)".
# Install network tools
apk add --no-cache curl netcat-openbsd

# Set network status
echo "NETWORK_READY=true" >> $EXEC_OUTPUT
echo "IP_ADDRESS=$(hostname -i)" >> $EXEC_OUTPUT
