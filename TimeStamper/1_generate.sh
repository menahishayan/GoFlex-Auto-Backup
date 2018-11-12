#!/bin/bash

for d in *
do
    if [ -d "$d" ]; then
        echo "$d"
        cd "$d"
        `~/Desktop/save-file-attrs.py save`
        cd ..
    fi
done
