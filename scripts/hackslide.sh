#!/bin/bash

# Usage: hackslide <window> <open/close/toggle>

PWD="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

STAT="$(eww -c $PWD get reveal$1)"
WINDOW=$1
ACTION=$2

close()  {
    eww -c $PWD update reveal$WINDOW=false
    if pidof picom; then
        sleep 0.5
    fi
    STAT="$(eww -c $PWD get reveal$WINDOW)"
    OPEN="$(eww -c $PWD active-windows | grep $WINDOW)"
    if [[ $STAT == "false" && $OPEN ]]; then 
        eww -c $PWD close $WINDOW
    fi
}

open()  {
    $PWD/scripts/winpos.sh $WINDOW open
    eww -c $PWD update reveal$WINDOW=true
}

if [[ $ACTION == "close" && $STAT == "true" ]]; then
    close
elif [[ $ACTION == "open" && $STAT == "false" ]]; then
    open
elif [[ $ACTION == "toggle" ]]; then
    [ $STAT == "true" ] && close || open
fi

