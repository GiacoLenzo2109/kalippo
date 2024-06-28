#!/bin/bash

function install_nmap_automator() {
    # NmapAutomator
    git clone https://github.com/21y4d/nmapAutomator.git > /dev/null 2>&1
    sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/ > /dev/null 2>&1 & start_spinner "nmapAutomator"
}

function install_impacket() {
    if dpkg -s impacket-scripts | grep "not installed" &> /dev/null; then
        echo "Impacket is already installed. Do you want to uninstall it and proceed installing git version? (Y/N)"
        read answer
        if [ "$answer" == "y" ]; then
            sudo apt remove impacket-scripts
        fi
    fi
    install_tool_pipx "Impacket" "impacket"
}


function install_network_tools() {
    CURRENT_COLOR=$CYAN

    category "Network Tools"
    folder "Network"

    # Linux
    install_nmap_automator

    # NetExec
    # install_tool_pipx "NetExec" "git+https://github.com/Pennyw0rth/NetExec"

    # Impacket
    install_impacket

    # SMBClientNG
    install_tool_pip "smbclientng"

    # Others
    for tool in "${network_tools[@]}"; do
        install_tool $tool
    done
}