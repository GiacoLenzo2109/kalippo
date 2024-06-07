#!/bin/bash

network_tools=(
    "autorecon" 
    "dnsrecon" 
    "enum4linux" 
    "nikto" 
    "bloodhound" 
    "bloodhound.py" 
    "mimikatz" 
    "pypykatz" 
    "crackmapexec" 
    "impacket-scripts" 
    "evil-winrm"
)

function nmap_automator() {
    # NmapAutomator
    git clone https://github.com/21y4d/nmapAutomator.git > /dev/null 2>&1
    sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/ > /dev/null 2>&1 & start_spinner "nmapAutomator"
}

function powersploit() {
    # PowerSploit
    download_tool "PowerSploit" "https://github.com/PowerShellMafia/PowerSploit/archive/refs/tags/v3.0.0.zip"
    unzip v3.0.0.zip > /dev/null 2>&1
    rm v3.0.0.zip > /dev/null 2>&1
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

    download_tool "LaZagne" "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.5/LaZagne.exe"

    # Linux
    subcategory "Linux Tools"
    folder "Network/Linux"

    # NetExec
    install_tool_pipx "NetExec" "git+https://github.com/Pennyw0rth/NetExec"

    # SMBClientNG
    install_tool_pip "smbclientng"

    # Others
    for tool in "${network_tools[@]}"; do
        install_tool $tool
    done
}