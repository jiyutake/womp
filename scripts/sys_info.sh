#!/bin/bash

## Files and Data
PREV_TOTAL=0
PREV_IDLE=0
cpuFile="/tmp/.cpu_usage"

## Get CPU usage
get_cpu() {
	if [[ -f "${cpuFile}" ]]; then
		fileCont=$(cat "${cpuFile}")
		PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
		PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
	fi

	CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
	unset CPU[0]                          # Discard the "cpu" prefix.
	IDLE=${CPU[4]}                        # Get the idle CPU time.

	# Calculate the total CPU time.
	TOTAL=0

	for VALUE in "${CPU[@]:0:4}"; do
		let "TOTAL=$TOTAL+$VALUE"
	done

	if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
		# Calculate the CPU usage since we last checked.
		let "DIFF_IDLE=$IDLE-$PREV_IDLE"
		let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
		let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
		echo "${DIFF_USAGE}"
	else
		echo "?"
	fi

	# Remember the total and idle CPU times for the next check.
	echo "${TOTAL}" > "${cpuFile}"
	echo "${IDLE}" >> "${cpuFile}"
}

## Get Used memory
get_mem() {
	printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
}

## Get Brightness
get_blight() {
	CARD=`ls /sys/class/backlight | head -n 1`

	if [[ "$CARD" == *"intel_"* ]]; then
		BNESS=`xbacklight -get`
		LIGHT=${BNESS%.*}
	else
		BNESS=`blight -d $CARD get brightness`
		PERC="$(($BNESS*100/255))"
		LIGHT=${PERC%.*}
	fi

	echo "$LIGHT"
}

## Get Battery 
get_battery() {
    battery_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
    battery_percentage=$(echo "$battery_info" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
    battery_state=$(echo "$battery_info" | grep -E "state" | awk '{print $2}')

    case $battery_state in
        "discharging")
            if [ "$battery_percentage" -le 10 ]; then
                notify-send -a battery "Desktop" "io'm m tired....,,... (10% battery left)"
            elif [ "$battery_percentage" -le 15 ]; then
                notify-send -a battery "Desktop" "getting eepy (15% battery left)"
            fi
            ;;
    esac

    echo $battery_percentage
}

get_battery_icon () {
    battery_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
    battery_percentage=$(echo "$battery_info" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
    icon="󰁹"
    icons=("󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")

    for i in ${!icons[@]}; do 
        if [ $battery_percentage -le $((i*10)) ]; then 
            icon=${icons[$i]}
            break
        fi
    done

    echo $icon
}

get_vol_icon () {
    muted=$(pamixer --get-mute)
    icon="󰝟"
    if [[ $muted == "false" ]]; then 
        vol=$(pamixer --get-volume)

        if [[ vol -le 10 ]]; then
            icon="󰕿"
        elif [[ vol -le 30 ]]; then 
            icon="󰖀"
        else 
            icon="󰕾"
        fi
    fi

    echo $icon
}

## Execute accordingly
if [[ "$1" == "--cpu" ]]; then
	get_cpu
elif [[ "$1" == "--mem" ]]; then
	get_mem
elif [[ "$1" == "--blight" ]]; then
	get_blight
elif [[ "$1" == "--bat" ]]; then
	get_battery
elif [[ "$1" == "--baticon" ]]; then
	get_battery_icon
elif [[ "$1" == "--volicon" ]]; then
	get_vol_icon
fi
