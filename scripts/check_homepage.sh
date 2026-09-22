#!/bin/bash
# Source: /getting-started/code/content-tasks/ — "Build the Validation Script"

EXPECTED_MESSAGE="Hello from my web server!"
NGINX_HTML="/usr/share/nginx/html/index.html"

if grep -q "$EXPECTED_MESSAGE" "$NGINX_HTML"; then
  exit 0
else
  exit 1
fi
