#!/usr/bin/bash 

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

popup() {
    eww -c $EWW_DIR update osdstack=$1
    count=$(eww -c $EWW_DIR get osdcount)
    
    if [ $count == 0 ]; then 
        $EWW_DIR/scripts/hackslide.sh osd osdreveal &
    fi

    eww -c $EWW_DIR update osdcount=$((count+1))

    sleep 2 

    count=$(eww -c $EWW_DIR get osdcount)
    eww -c $EWW_DIR update osdcount=$((count-1))
    if [ $count == 1 ]; then 
        $EWW_DIR/scripts/hackslide.sh osd osdreveal close &
    fi
}

case "$1" in
    volume)
        case "$2" in
            increase)
                pamixer -i 5 
            ;;
            decrease)
                pamixer -d 5
            ;;
            toggle)
                pamixer --toggle-mute
            ;;
        esac
        eww -c $EWW_DIR update volume=$(pamixer --get-volume)
        eww -c $EWW_DIR update volumemute=$(pamixer --get-mute)
        popup 0
    ;;
    brightness)
        case "$2" in
            increase)
                brightnessctl set +5%
            ;;
            decrease)
                brightnessctl set 5%-
            ;;
        esac
        eww -c $EWW_DIR update brightness=$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}' | tr -d '%')
        popup 1
    ;;
esac

