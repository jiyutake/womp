#!/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

update () {
    STAT=`eww -c $EWW_DIR active-windows | grep bar`

    if [[ $1 == "off" ]]; then 
        [[ -z $STAT ]] && eww -c $EWW_DIR open bar
    else
        [[ $STAT ]] && eww -c $EWW_DIR close bar
    fi
}

bspc subscribe node_state | while read -r _ _ _ _ type state; do 
    if [[ $type == "fullscreen" ]]; then 
        update $state
    fi
done
