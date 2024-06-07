#!/bin/bash

source utils/colors.sh
source utils/functions/generic.sh

function show_banner() {
    RANDOM_COLOR=$(shuf -i 1-7 -n 1)
    case $RANDOM_COLOR in
        1) CURRENT_COLOR=$RED;;
        2) CURRENT_COLOR=$GREEN;;
        3) CURRENT_COLOR=$YELLOW;;
        4) CURRENT_COLOR=$BLUE;;
        5) CURRENT_COLOR=$MAGENTA;;
        6) CURRENT_COLOR=$CYAN;;
        7) CURRENT_COLOR=$WHITE;;
    esac
    source utils/colors.sh
    echo -e "${CURRENT_COLOR}"
    echo ' ___  __    ________  ___       ___          ________  _______  _________  ___  ___  ________'
    echo '|\  \|\  \ |\   __  \|\  \     |\  \        |\   ____\|\  ___ \|\___   ___\\  \|\  \|\   __  \'
    echo '\ \  \/  /|\ \  \|\  \ \  \    \ \  \       \ \  \___|\ \   __/\|___ \  \_\ \  \\\  \ \  \|\  \'
    echo ' \ \   ___  \ \   __  \ \  \    \ \  \       \ \_____  \ \  \_|/__  \ \  \ \ \  \\\  \ \   ____\'
    echo '  \ \  \\ \  \ \  \ \  \ \  \____\ \  \       \|____|\  \ \  \_|\ \  \ \  \ \ \  \\\  \ \  \___|'
    echo '   \ \__\\ \__\ \__\ \__\ \_______\ \__\        ____\_\  \ \_______\  \ \__\ \ \_______\ \__\'
    echo '    \|__| \|__|\|__|\|__|\|_______|\|__|       |\_________\|_______|   \|__|  \|_______|\|__|'
    echo '                                               \|_________|'
    echo "                                                                          Author: @GiacoLenzo2109"
    echo -e "${NC}"
}