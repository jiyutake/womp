#!/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

eww -c $EWW_DIR open-many bar screenborder

# remove border from all eww windows
bspc rule -a Eww border=off state=floating

