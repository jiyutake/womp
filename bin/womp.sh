#!/usr/bin/bash

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

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

    \e[1mtheme\e[22m
        \e[4mUsage\e[24m: womp.sh theme <THEME>
        Set a theme
        \e[1mTHEME\e[22m
            rosepine
            rosepine_dawn
            rosepine_moon
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

'   
}

case $1 in 
    start) 
        $EWW_DIR/bin/start.sh
    ;;
    window)
        case "$3" in
            applauncher|notificationlog|systemctl) 
                case "$2" in
                    open|toggle)
                        $EWW_DIR/scripts/hackslide.sh $3 reveal$3 &> /dev/null &
                    ;;
                    close)
                        $EWW_DIR/scripts/hackslide.sh $3 reveal$3 close &> /dev/null &
                    ;;
                    *) 
                        help
                        exit 1
                    ;;
                esac
                
            ;;
            bar|screenborder|recordplayer) 
                case "$2" in
                    open)
                        eww -c $EWW_DIR open $3
                    ;;
                    toggle)
                        eww -c $EWW_DIR open $3 --toggle
                    ;;
                    close)
                        eww -c $EWW_DIR close $3
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
    help|*) 
        help
    ;;
esac

