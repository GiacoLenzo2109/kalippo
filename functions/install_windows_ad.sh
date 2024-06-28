#!/bin/bash

POWERSPLOIT_VERSION="v3.0.0"

function install_powerview() {
    # PowerSploit
    download_tool "PowerSploit" "https://github.com/PowerShellMafia/PowerSploit/raw/master/Recon/PowerView.ps1"
    # unzip ${POWERSPLOIT_VERSION}.zip > /dev/null 2>&1
    # rm ${POWERSPLOIT_VERSION}.zip > /dev/null 2>&1
}

function install_ntlm_theft() {
    pip3 install xlsxwriter
    clone_tool "NTLMTheft" "https://github.com/Greenwolf/ntlm_theft.git"
}

function install_windows_ad_tools() {
    # Windows AD Tools
    subcategory "Windows AD Tools"
    folder "Windows_AD"

    install_powerview

    install_ntlm_theft

    download_tool "Mimikatz" "https://raw.githubusercontent.com/ParrotSec/mimikatz/master/x64/mimikatz.exe"

    download_tool "Rubeus" "https://raw.githubusercontent.com/r3motecontrol/Ghostpack-CompiledBinaries/master/Rubeus.exe"
}