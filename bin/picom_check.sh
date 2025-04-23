#!/usr/bin/bash

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

# unironically works better to just kill and reopen womp
killall eww
$EWW_DIR/bin/start.sh &
