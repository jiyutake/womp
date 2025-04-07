#!/usr/bin/bash

EWW_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

eww -c $EWW_DIR close bar
eww -c $EWW_DIR open lockscreen
