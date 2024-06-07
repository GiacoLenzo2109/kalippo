#!/bin/bash

seclists=(
    "seclists"
)


function install_seclists() {
    CURRENT_COLOR=$YELLOW
    # Seclists 
    folder "Seclists"

    category "Seclists"
    for tool in "${seclists[@]}"; do
        install_tool $tool
    done
}