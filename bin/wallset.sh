#!/bin/bash 

if [ $1 == "set" ]; then 
    feh --bg-fill $2
elif [ $1 == "get" ]; then 
    if [ -f $HOME/.fehbg ]; then
        cat $HOME/.fehbg | sed -n 2p | cut -d "'" -f 2
    fi
elif [ $1 == "pick" ]; then 
    bg=$(zenity --file-selection --title 'Select Wallpaper' --file-filter='Image files (png, jpg) | *.png *.jpg *.jpeg')
    feh --bg-fill $bg
elif [[ $1 == "restore" ]]; then
    bash $HOME/.fehbg
fi 
