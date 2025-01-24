#!/bin/bash

PWD="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."


STAT="$(eww -c $PWD get $2)"
if [[ $STAT == "true" || $3 == "close" ]]; then
    eww -c $PWD update "$2"=false
    if pidof picom; then
        sleep 0.5
    fi
    STAT="$(eww -c $PWD get $2)"
    OPEN="$(eww -c $PWD active-windows | grep $1)"
    if [[ $STAT == "false" && $OPEN ]]; then 
        eww -c $PWD close $1
    fi
else
    eww -c $PWD open $1
    eww -c $PWD update "$2"=true
fi

