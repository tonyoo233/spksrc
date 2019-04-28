#!/bin/sh

# Add's randomness when running cron job (0-20 minutes)
# Be nice to servers and don't update at exactly midnight or exactly on an hour
[ -n "$RANDOM" ] && sleep $(($RANDOM %1200))

cd /var/packages/dnscrypt-proxy/target/var/ || exit
python generate-domains-blacklist.py > blacklist.txt.tmp && mv -f blacklist.txt.tmp blacklist.txt
echo "## Last updated at: $(date)" >> blacklist.txt
