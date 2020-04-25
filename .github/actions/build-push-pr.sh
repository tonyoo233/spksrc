#!/bin/bash

# echo "FILES: $FILES"

# filter for changes made in the cross and spk directories
FILES=$(echo "$FILES" | grep -oE "(spk.*)|(cross.*)")

# create array of potential packages where files have changed
PACKAGES_ARR=()
for FILE in $FILES
do
    # remove leading spk and cross from string
    FILE=${FILE#spk/}
    FILE=${FILE#cross/}
    # get package name / folder name
    PACKAGE=$(echo "$FILE" | grep -oE "^[^\/]*")
    # echo "PACKAGE: $PACKAGE"
    PACKAGES_ARR+=("$PACKAGE")
done

# de-duplicate packages
PACKAGES=$(printf %s "${PACKAGES_ARR[*]}" | tr ' ' '\n' | sort -u)

if [ -z "$PACKAGES" ]; then
    echo "no package built. Empty PACKAGES var"
    exit 0
fi

echo "===> PACKAGES to Build: $PACKAGES"

for PACKAGE in $PACKAGES
do
    # make sure that the package exists
    if [ -d "spk/$PACKAGE" ]; then
        cd spk/"$PACKAGE" && make "$1"
    else
        # must be from cross/
        echo "$PACKAGE is not a spk PACKAGE" # TODO: maybe find depended packages
    fi
done
