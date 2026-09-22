#!/bin/sh
# Source: /reference/content/task/ — "Full Syntax" (cleanup script).
# Runs when the condition completes (success or skip).
rm -f "$MARKER_DIR/service_checks_ready"
