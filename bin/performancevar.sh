#!/usr/bin/bash

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."
CONF="$HOME/.cache/eww/performance.json"


if [[ ! -f $CONF ]]; then 
    mkdir -p $(dirname $CONF)
    touch $CONF
    echo '{"compositor": true, "fullscreen_check": true, "lyrics": true, "record_player": true, "battery_anim": true}' > $CONF
fi

if [[ $1 == "get" ]]; then 
    echo $(jq -r ".$2 // false" $CONF)
elif [[ $1 == "set" ]]; then
    echo $(jq ".$2 = $3" $CONF) > $CONF
elif [[ $1 == "toggle" ]]; then
    VAR=$(jq -r ".$2 // false" $CONF)
    if [ $VAR == "true" ]; then 
        echo $(jq ".$2 = false" $CONF) > $CONF
    else
        echo $(jq ".$2 = true" $CONF) > $CONF
    fi
fi
