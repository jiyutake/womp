#!/bin/bash

# Checks if a list ($1) contains an element ($2)
contains() {
    for e in $1; do
        [ "$e" = "$2" ] && echo 1 && return 
    done; echo 0
} 

print_workspaces() { 
    buf=""
    desktops=$(bspc query -D --names)
    focused_desktop=$(bspc query -D -d focused --names)
    occupied_desktops=$(bspc query -D -d .occupied --names)
    urgent_desktops=$(bspc query -D -d .urgent --names)
    for d in $desktops; do
        if [ "$(contains "$focused_desktop" "$d")" -eq 1 ]; then
            ws=$d
            class="focused"
        elif [ "$(contains "$occupied_desktops" "$d")" -eq 1 ]; then
            ws=$d
            class="occupied"
        elif [ "$(contains "$urgent_desktops" "$d")" -eq 1 ]; then
            ws=$d
            class="urgent"
        else 
            ws=$d
            class="empty"
        fi  
        buf="$buf\"$class\","
    done
    echo "[${buf%,}]"
} 
print_workspaces
bspc subscribe desktop node_transfer | while read -r _ ; do
    print_workspaces
done 
