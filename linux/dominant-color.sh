#!/bin/sh

convert "$1" -colors 16 -depth 8 -format '%c' histogram:info: | perl -pe 's/\s(?=.*:)/0/g' | sort -r | head -q -n1 | perl -pe 's/.*srgb\((.+)\)/\1/'
