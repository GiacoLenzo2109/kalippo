#!/bin/bash

function install_pivoting() {
    CURRENT_COLOR=$GREEN
    #Pivoting
    category "Pivoting"
    folder "Pivoting"

    # Chisel
    download_tool "Chisel" "https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz" && gzip -d chisel_1.9.1_linux_amd64.gz > /dev/null 2>&1 && rm chisel_1.9.1_linux_amd64.gz
}