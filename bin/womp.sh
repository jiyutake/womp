#!/usr/bin/bash

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE
done
EWW_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )/.."

help() {
    echo -e '
\e[4mUsage\e[24m: womp.sh <COMMAND>

\e[1mCOMMAND\e[22m
    \e[1mstart\e[22m
        \e[4mUsage\e[24m: womp.sh start
        Launches the shell properly

    \e[1mwindow\e[22m
        \e[4mUsage\e[24m: womp.sh window <OPTION> <WINDOW>
        Open, close, or toggle a window.
        \e[1mOPTION\e[22m
            open
            close
            toggle
        \e[1mWINDOW\e[22m
            bar 
            screenborder 
            applauncher
            recordplayer
            notificationlog
            systemctl
            themectl

    \e[1mtheme\e[22m
        \e[4mUsage\e[24m: womp.sh theme <THEME>
        Set a theme
        \e[1mTHEME\e[22m
            rosepine
            rosepine_dawn
            rosepine_moon
            oxocarbon
    \e[1mcompositor\e[22m
        \e[4mUsage\e[24m: womp.sh compositor <OPTION>
        Start/ends picom, will also Enables/disables transparency options based on this. 
        \e[1mOPTION\e[22m
            open 
                launches picom
            close
                closes picom
            toggle
                toggles picom
            check
                checks picom status and enables/disables transparency accordingly
            poll 
                continuously checks picom status and enables/disbles transparency accordingly

    \e[1mvolume\e[22m
        \e[4mUsage\e[24m: womp.sh volume <OPTION>
        Control system volume, also opens an indicator popup window
        \e[1mOPTION\e[22m
            increase
            decrease
            toggle

    \e[1mbrightness\e[22m
        \e[4mUsage\e[24m: womp.sh brightness <OPTION>
        Control system brightness, also opens an indicator popup window
        \e[1mOPTION\e[22m
            increase
            decrease

    \e[1manchor\e[22m
        \e[4mUsage\e[24m: womp.sh anchor <WINDOW> <ANCHOR>
        Set the anchor of a popup window
        \e[1mWINDOW\e[22m
            osd
            notifications
            recordplayer
            notificationlog
            applauncher
            themectl
        \e[1mANCHOR\e[22m
            top left
            top center
            top right
            center
            bottom left
            bottom center
            bottom right

    \e[1mwallpaper\e[22m
        \e[4mUsage\e[24m: womp.sh wallpaper <OPTION> [FILE]
        Wallpaper options
        \e[1mOPTION\e[22m
            set 
            get
            pick
            restore
    \e[1mlock\e[22m
        \e[4mUsage\e[24m: womp.sh lock
'           
}

case $1 in 
    start) 
        $EWW_DIR/bin/start.sh
    ;;
    window)
        case "$3" in
            applauncher|notificationlog|systemctl|bar|screenborder|recordplayer|themectl) 
                case "$2" in
                    open|toggle|close)
                        $EWW_DIR/scripts/winpos.sh $3 $2
                    ;;
                    *) 
                        help
                        exit 1
                    ;;
                esac
            ;;
            *) 
                help 
                exit 1
            ;;
        esac
    ;;
    theme)
        $EWW_DIR/bin/set_theme.sh $2
    ;;
    compositor)
        case "$2" in
            open)
                picom -b
                $EWW_DIR/bin/picom_check.sh
            ;;
            close)
                pkill picom
                $EWW_DIR/bin/picom_check.sh
            ;;
            toggle) 
                if pidof picom; then
                    pkill picom
                else 
                    picom -b
                fi
                $EWW_DIR/bin/picom_check.sh
            ;;
            check) 
                $EWW_DIR/bin/picom_check.sh
            ;;
            *)
                help
            ;;
        esac
        
    ;;
    volume) 
        case "$2" in
            increase|decrease|toggle) 
                $EWW_DIR/bin/osd.sh volume $2 &
            ;;
            *) 
                help
            ;;
        esac
    ;;
    brightness) 
        case "$2" in
            increase|decrease) 
                $EWW_DIR/bin/osd.sh brightness $2 &
            ;;
            *) 
                help
            ;;
        esac
    ;;
    anchor)
        case "$2" in
            notifications|osd|recordplayer|notificationlog|applauncher|themectl) 
                WIN=$2
                POSCONFIG="$HOME/.cache/eww/winpositions.json"
                shift 2
                case "$*" in 
                    "top left"| \
                    "top right"| \
                    "top center"| \
                    "center"| \
                    "center left"| \
                    "center right"| \
                    "bottom left"| \
                    "bottom right"| \
                    "bottom center") 
                        echo $(jq ".$WIN = \"$*\"" $POSCONFIG) > $POSCONFIG
                    ;;
                    *)
                        help
                    ;;
                esac
            ;;
            *) 
                help
            ;;
        esac
    ;;
    wallpaper)
        $EWW_DIR/bin/wallset.sh $2 $3
    ;;
    lock)
        $EWW_DIR/bin/lock.sh
    ;;
    help|*) 
        help
    ;;
esac

