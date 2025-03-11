#!/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

THEME=$($EWW_DIR/scripts/parsetheme.py)
bspc config normal_border_color $(echo $THEME | jq -r '.muted')
bspc config active_border_color $(echo $THEME | jq -r  '."highlight"')

# remove border from all eww windows
bspc rule -a Eww border=off state=floating
bspc rule -a zenity border=off state=floating

# leave gap
bspc config -m ^1 left_padding 60px

# if pidof picom; then 
#     eww -c $EWW_DIR open-many bar keepopen screenborder
# else
#     eww -c $EWW_DIR open-many bar keepopen
# fi
eww -c $EWW_DIR open-many bar keepopen

$EWW_DIR/bin/wallset.sh restore
