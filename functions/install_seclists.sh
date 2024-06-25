#!/bin/bash

function install_seclists() {
    CURRENT_COLOR=$BLUE
    # Seclists 
    folder "Seclists"

    category "Seclists"
    for tool in "${seclists[@]}"; do
        install_tool $tool
    done
}