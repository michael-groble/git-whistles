#!/bin/sh
#
# git-merge-po --
# 
#   Custom Git merge driver - merges PO files using msgcat(1)
# 
O=$1
A=$2
B=$3

# Extract the PO header from the current branch (top of file until first empty line)
header=$(mktemp /tmp/merge-po.XXXX)
sed -e '/^$/q' < $A > $header

# Merge files, then repair header
temp=$(mktemp /tmp/merge-po.XXXX)
msgcat -o $temp $A $B
msgcat --use-first -o $A $header $temp

# Clean up
rm $header $temp

# Check for conflicts
conflicts=$(grep -c "#-#" $A)
test $conflicts -gt 0 && exit 1
exit 0
