#!/bin/bash

source functions/install_web_tools.sh
source functions/install_seclists.sh
source functions/install_kernel_exploits.sh
source functions/install_privesc.sh
source functions/install_password_crackers.sh
source functions/install_tunneling.sh
source functions/install_network_tools.sh
source functions/install_windows_ad.sh

#################################################################### Tools ####################################################################

# Function to install a tool
function install_tool() {
    tool_name=$1
    sudo apt-get install -y $tool_name > /dev/null 2>&1 & start_spinner $tool_name
}

function install_tool_pip() {
    tool_name=$1
    pip install $tool_name --break-system-packages > /dev/null 2>&1 & start_spinner $tool_name
}

function install_tool_pipx() {
    tool_name=$1
    pipx install $2 > /dev/null 2>&1 & start_spinner $tool_name
}

function download_tool() {
    tool_name=$1
    wget $2 > /dev/null 2>&1 & start_spinner $tool_name
}

function clone_tool() {
    tool_name=$1
    git clone $2 > /dev/null 2>&1 & start_spinner $tool_name
}

# Update package lists
function update_package_lists() {
    echo "Updating package lists..."
    sudo apt-get update
}

function pipx_install() {
    sudo apt install python3-venv  > /dev/null 2>&1
    python3 -m pip install --user pipx  > /dev/null 2>&1 & start_spinner "pipx"
    python3 -m pipx ensurepath  > /dev/null 2>&1
}

function install_packages() {
    total_tools=0
    current_tool=0

    pipx_install
    
    for package in "${PACKAGES[@]}"; do
        case $package in
            "all")
                install_network_tools
                install_web_tools
                install_seclists
                install_kernel_exploits
                install_privesc
                install_password_tools
                install_tunneling
                install_windows_ad_tools
                total_tools=$(( ${#network_tools[@]} + ${#web_tools[@]} + ${#seclists[@]} + 2 + 12 + ${#password_tools[@]} + 2))
                ;;
            "ad")
                install_windows_ad_tools
                total_tools=$(( ${total_tools} + 3))
                ;;
            "network")
                install_network_tools
                total_tools=$(( ${total_tools} + ${#network_tools[@]}))
                ;;
            "web")
                install_web_tools
                total_tools=$(( ${total_tools} + ${#web_tools[@]}))
                ;;
            "seclists")
                install_seclists
                total_tools=$(( ${total_tools} + ${#seclists[@]}))
                ;;
            "kernel-exploits")
                install_kernel_exploits
                total_tools=$(( ${total_tools} + 2))
                ;;
            "privesc")
                install_privesc
                total_tools=$(( ${total_tools} + 12))
                ;;
            "password-crackers")
                install_password_tools
                total_tools=$(( ${total_tools} + ${#password_tools[@]}))
                ;;
            "tunneling")
                install_tunneling
                total_tools=$(( ${total_tools} + 2))
                ;;
            *)
                echo "Unknown category: $package"
                show_help
                exit 1
                ;;
        esac
    done
    
    echo "Total tools: $total_tools"
    exit 0
}


############################################################################## ALIAS ##############################################################################

function install_aliases() {
    echo "Do you want to install the aliases? [Y/N]"
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
        alias pyserver="python3 -m http.server $1"
        alias cme="crackmapexec"
    fi
}