#!/bin/bash

for d in *
do
    if [ -d "$d" ]; then
        echo "$d"
        cd "$d"
        `/home/shares/public/save-file-attrs.py restore`
        cd ..
    fi
done
