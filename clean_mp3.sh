#!/bin/bash

if [ $# -eq 0 ]; then
    echo "usage: $0 [*.txt]"
    exit 0
fi

while read line; do
    # reading each line
    echo "delete $line"
    rm $line
done <$1
