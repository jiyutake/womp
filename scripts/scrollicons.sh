#!/bin/bash

VAL=$(eww -c ./ get scrolliconsindex)

if [ $1 == "up" ]; then 
    VAL=$((VAL - 1))
else 
    VAL=$((VAL + 1))
fi

VAL=$(( VAL >= $2 ? $2-1 : VAL))
VAL=$(( VAL < 0 ? 0 : VAL))
eww -c ./ update scrolliconsindex=$VAL
