#!/bin/bash
# Source: /reference/sandbox/utilities/exec/ — "Local Script Execution (Local Mode)"
# and "Output Variables".
echo "Setting up environment..."

# Set output variables
echo "STATUS=completed" >> $EXEC_OUTPUT
echo "COUNT=42" >> $EXEC_OUTPUT
echo "MESSAGE=Hello World" >> $EXEC_OUTPUT
echo "SETUP_COMPLETE=true" >> $EXEC_OUTPUT
echo "VERSION=1.0.0" >> $EXEC_OUTPUT
