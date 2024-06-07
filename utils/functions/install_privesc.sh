#!/bin/bash

function install_privesc() {
    CURRENT_COLOR=$CYAN
    # Privesc
    category "Privesc"
    folder "Privesc"

    # Windows Privesc
    folder "Privesc/Windows"
    subcategory "Windows Privesc"

    install_tool_pip "wesng"


    download_tool "WinPEASx64" "https://github.com/peass-ng/PEASS-ng/releases/download/20240602-829055f0/winPEASx64.exe"
    download_tool "WinPEASx86" "https://github.com/peass-ng/PEASS-ng/releases/download/20240602-829055f0/winPEASx86.exe"

    download_tool "JAWS" "https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1"

    subcategory "Windows Token Impersonation - Patatone.exe"
    download_tool "PrintSpoofer64" "https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer64.exe"
    download_tool "RoguePotato" "https://github.com/antonioCoco/RoguePotato/releases/download/1.0/RoguePotato.zip" && unzip RoguePotato.zip > /dev/null 2>&1
    download_tool "SharpEfsPotato" "https://github.com/jakobfriedl/precompiled-binaries/raw/main/Token/SharpEfsPotato.exe"
    download_tool "JuicyPotato" "https://github.com/jakobfriedl/precompiled-binaries/raw/main/Token/JuicyPotato.exe"
    download_tool "GodPotato" "https://github.com/jakobfriedl/precompiled-binaries/raw/main/Token/GodPotato.exe"

    # Linux Privesc
    folder "Privesc/Linux"
    subcategory "Linux Privesc"

    download_tool "Linxu Exploit Suggester" "https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh"

    download_tool "LinEnum" "https://github.com/rebootuser/LinEnum/blob/master/LinEnum.sh"

    download_tool "LinPEAS" "https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh" 
}