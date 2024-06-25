#!/bin/bash

source utils/colors.sh
source functions/generic.sh

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
    echo "    __ __      ___                 "
    echo "   / //_/___ _/ (_)___  ____  ____ "
    echo "  / ,< / __ \`/ / / __ \/ __ \/ __ \\"
    echo " / /| / /_/ / / / /_/ / /_/ / /_/ /"
    echo "/_/ |_\__,_/_/_/ .___/ .___/\____/ "
    echo "              /_/   /_/            "
    echo "            Author: @GiacoLenzo2109"
    echo -e "${NC}"
}