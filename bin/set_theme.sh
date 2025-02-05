#!/usr/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

case "$1" in
    rosepine|rosepine_dawn|rosepine_moon) 
        echo @import \"./themes/$1.scss\" > $EWW_DIR/theme.scss
        THEME=$($EWW_DIR/scripts/parsetheme.py)
        bspc config normal_border_color $(echo $THEME | jq -r '.muted')
        bspc config active_border_color $(echo $THEME | jq -r  '."highlight-med"')
        eww -c $EWW_DIR reload
    ;;
    *)
        echo "Theme not yet added :despair:"
    ;;
esac

