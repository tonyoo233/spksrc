#!/bin/bash

# PACKAGE=$(echo "refs/tags/dnscrypt-proxy-2.0.42" | grep -oE "([0-9a-zA-Z]*-)*")
PACKAGE=$(echo "$GITHUB_REF" | grep -oE "([0-9a-zA-Z]*-)*")
PACKAGE="${PACKAGE::-1}"
echo "$PACKAGE"


cd spk/"$PACKAGE" && make "$1"
