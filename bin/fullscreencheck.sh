#!/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."
STAT=`eww -c $EWW_DIR active-windows | grep bar`

if [[ -z `bspc query -N -n focused.fullscreen` ]]; then 
    if pidof picom; then 
        [[ -z $STAT ]] && eww -c $EWW_DIR open-many bar screenborder
    else 
        [[ -z $STAT ]] && eww -c $EWW_DIR open bar
    fi
else
    [[ $STAT ]] && eww -c $EWW_DIR close-all
fi


