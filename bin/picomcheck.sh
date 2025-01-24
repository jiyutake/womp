#!/usr/bin/bash

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

STAT=`eww -c $EWW_DIR active-windows | grep screenborder`

if pidof picom; then 
    # enable transparency features
    [[ -z $STAT ]] && eww -c $EWW_DIR open screenborder
else
    # disable transparency features
    [[ $STAT ]] && eww -c $EWW_DIR close screenborder
fi
eww -c $EWW_DIR reload
