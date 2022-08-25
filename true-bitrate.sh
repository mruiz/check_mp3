#!/bin/bash

CONVERT=$(which ffmpeg)
if [ $? -eq 1 ]; then
    echo "Cannot find ffmpeg library, is it installed?"
    exit -1
fi
if [ $# -eq 0 ]; then
    echo "usage: $0 [folder]"
    exit 0
fi

rm -f truebitrate_$(basename $1).txt

for filename in $1/*; do
    if [[ $filename == *.mp3 ]] || [[ $filename == *.m4a ]]; then
        $CONVERT -loglevel panic -i "$filename" "/tmp/true_$$.wav"
        if [ -f "/tmp/true_$$.wav" ]; then
            bitrate=$(python true-bitrate.py "/tmp/true_$$.wav")
            if [[ $bitrate == "64"* ]] || [[ $bitrate == "128"* ]] || [[ $bitrate == "192"* ]] || [[ $bitrate == "error" ]]; then
                echo "$filename" >> truebitrate_$(basename $1).txt 
            fi
            RESULT=$?
            if [ $RESULT -ne 0 ]; then
                exit $RESULT
            fi
            rm "/tmp/true_$$.wav"
        fi
    fi
done

exit 0


