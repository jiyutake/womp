#!/usr/bin/bash

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

POSCONFIG="$HOME/.cache/eww/winpositions.json"

# This is the fastest way, trust. And I'm lazy.
declare -A ANCHORS=(
    ["top left"]='--anchor=top left'
    ["top right"]='--anchor=top right'
    ["top center"]='--anchor=top center'
    ["center"]='--anchor=center'
    ["center center"]='--anchor=center'
    ["bottom left"]='--anchor=bottom left'
    ["bottom right"]='--anchor=bottom right'
    ["bottom center"]='--anchor=bottom center'
)
declare -A POSITIONS=(
    ["top left"]='--pos=80x20'
    ["top right"]='--pos=-20x20'
    ["top center"]='--pos=0x20'
    ["center"]='--pos=0x0'
    ["center center"]='--pos=0x0'
    ["bottom left"]='--pos=80x-20'
    ["bottom right"]='--pos=-20x-20'
    ["bottom center"]='--pos=0x-20'
)

if [[ ! -f $POSCONFIG ]]; then 
    mkdir -p $(dirname $POSCONFIG)
    touch $POSCONFIG
    echo '{"osd": "top center", "notifications": "bottom center", "recordplayer": "bottom right", "notificationlog": "top right", "applauncher": "top left"}' > $POSCONFIG
fi
VAL=$(jq -r ".$1 // empty" $POSCONFIG)

open () {
    if [[ $VAL != "" ]]; then 
        eww -c $EWW_DIR open $1 "${ANCHORS[$VAL]}" "${POSITIONS[$VAL]}"
    else
        eww -c $EWW_DIR open $1
    fi
}

OPEN="$(eww -c $EWW_DIR active-windows | grep $1)"

if [[ $2 == "open" && !$OPEN ]]; then 
    open $1
elif [[ $2 == "close" && $OPEN ]]; then 
    eww -c $EWW_DIR close $1
else 
    if [[ $OPEN ]]; then 
        eww -c $EWW_DIR close $1
    else
        open $1
    fi
fi
