#!/bin/sh
# Source: /reference/sandbox/compute/container/ — "Running Scripts"
# Setup script executed inside the workstation container by resource.exec.setup.
echo "Welcome to the Docs Example Gallery workstation" > /etc/motd
mkdir -p /root/workspace
echo "This directory was created by the exec setup script." > /root/workspace/README.txt
