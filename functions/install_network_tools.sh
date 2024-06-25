#!/bin/bash

POWERSPLOIT_VERSION="v3.0.0"
LAZAGNE_VERSION="v2.4.5"

function nmap_automator() {
    # NmapAutomator
    git clone https://github.com/21y4d/nmapAutomator.git > /dev/null 2>&1
    sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/ > /dev/null 2>&1 & start_spinner "nmapAutomator"
}

function powersploit() {
    # PowerSploit
    download_tool "PowerSploit" "https://github.com/PowerShellMafia/PowerSploit/raw/master/Recon/PowerView.ps1"
    # unzip ${POWERSPLOIT_VERSION}.zip > /dev/null 2>&1
    # rm ${POWERSPLOIT_VERSION}.zip > /dev/null 2>&1
}

function impacket() {
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

    # Recon Tools
    subcategory "Recon Tools"
    folder "Recon"
    
    nmap_automator

    folder "Network"

    # Windows AD Tools
    subcategory "Windows Tools"
    folder "Network/Windows"

    powersploit

    download_tool "Mimikatz" "https://raw.githubusercontent.com/ParrotSec/mimikatz/master/x64/mimikatz.exe"

    download_tool "Rubeus" "https://raw.githubusercontent.com/r3motecontrol/Ghostpack-CompiledBinaries/master/Rubeus.exe"

    download_tool "LaZagne" "https://github.com/AlessandroZ/LaZagne/releases/download/${LAZAGNE_VERSION}/LaZagne.exe"

    # Linux
    subcategory "Linux Tools"
    folder "Network/Linux"

    # NetExec
    install_tool_pipx "NetExec" "git+https://github.com/Pennyw0rth/NetExec"

    # Impacket
    impacket

    # SMBClientNG
    install_tool_pip "smbclientng"

    # Others
    for tool in "${network_tools[@]}"; do
        install_tool $tool
    done
}