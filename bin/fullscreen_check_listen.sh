#!/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

update () {
    STAT=`eww -c $EWW_DIR active-windows | grep bar`

    if [[ -z `bspc query -N -n focused.fullscreen` ]]; then 
        [[ -z $STAT ]] && eww -c $EWW_DIR open bar
    else
        [[ $STAT ]] && eww -c $EWW_DIR close bar
    fi
}

PRIMARY=$(bspc query -M -m primary)

bspc subscribe node_state node_remove desktop_focus | while read -r _ monitor _ _ type state; do 
    if [[ $monitor == $PRIMARY ]]; then 
        update
    fi
done
