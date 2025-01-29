#!/usr/bin/bash

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

STAT=0
while true; do
    V="$(pidof picom)"
    if [[ $V != $STAT ]]; then 
        STAT=$V
        $EWW_DIR/bin/picom_check.sh
    fi
    sleep 5 
done


