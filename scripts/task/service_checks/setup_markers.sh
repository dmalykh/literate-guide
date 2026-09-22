#!/bin/sh
# Source: /reference/content/task/ — "Full Syntax" (setup script).
# Runs when the condition becomes active.
mkdir -p "$MARKER_DIR"
echo "service checks ready" > "$MARKER_DIR/service_checks_ready"
