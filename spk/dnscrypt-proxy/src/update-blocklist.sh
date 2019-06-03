#!/bin/sh

# Add randomness when running cron job (0-30 minutes)
# Be nice to servers and don't update at exactly midnight at the same time
# shellcheck disable=SC2039
[ -n "$RANDOM" ] && sleep $((RANDOM % 1800))

cd /var/packages/dnscrypt-proxy/target/var/ || exit
/usr/bin/env python generate-domains-blacklist.py > blocklist.txt.tmp && mv -f blocklist.txt.tmp blocklist.txt
echo "## Last updated at: $(date)" >> blocklist.txt
