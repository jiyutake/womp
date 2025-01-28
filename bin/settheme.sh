#!/usr/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

case "$1" in
    rosepine|rosepine_dawn|rosepine_moon) 
        echo @import \"./themes/$1.scss\" > $EWW_DIR/theme.scss
        $EWW_DIR/scripts/parsetheme.py &> /dev/null 
        eww -c $EWW_DIR reload
    ;;
esac

