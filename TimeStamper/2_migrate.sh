#!/bin/bash

for d in *
do
    if [ -d "$d" ]; then
        echo "$d"
        cp -a "$d/.saved-file-attrs" "/media/USB/shayan/$d/"
    fi
done
