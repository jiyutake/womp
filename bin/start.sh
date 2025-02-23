#!/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

THEME=$($EWW_DIR/scripts/parsetheme.py)
bspc config normal_border_color $(echo $THEME | jq -r '.muted')
bspc config active_border_color $(echo $THEME | jq -r  '."highlight"')

# remove border from all eww windows
bspc rule -a Eww border=off state=floating
bspc rule -a zenity border=off state=floating

if pidof picom; then 
    eww -c $EWW_DIR open-many bar screenborder keepopen
else
    eww -c $EWW_DIR open-many bar keepopen
fi
eww -c $EWW_DIR open-many bar screenborder keepopen
$EWW_DIR/bin/wallset.sh restore

pkill -f fullscreen_check_listen.sh 
$EWW_DIR/bin/fullscreen_check_listen.sh &

