#!/bin/bash

source utils/functions/install_web_tools.sh
source utils/functions/install_seclists.sh
source utils/functions/install_kernel_exploits.sh
source utils/functions/install_privesc.sh
source utils/functions/install_password_crackers.sh
source utils/functions/install_pivoting.sh
source  utils/functions/install_network_tools.sh

#################################################################### Tools ####################################################################

# Function to install a tool
function install_tool() {
    tool_name=$1
    sudo apt-get install -y $tool_name > /dev/null 2>&1 & start_spinner $tool_name
}

function install_tool_pip() {
    tool_name=$1
    pip install $tool_name > /dev/null 2>&1 & start_spinner $tool_name
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
    sudo apt-get update > /dev/null 2>&1
}

function pipx_install() {
    sudo apt install python3-venv  > /dev/null 2>&1
    python3 -m pip install --user pipx  > /dev/null 2>&1 & start_spinner "pipx"
    python3 -m pipx ensurepath  > /dev/null 2>&1
}

function install_packages() {
    total_tools=0
    current_tool=0
    
    for package in "${PACKAGES[@]}"; do
        case $package in
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
                install_password_crackers
                total_tools=$(( ${total_tools} + ${#password_cracker_tools[@]}))
                ;;
            "pivoting")
                install_pivoting
                total_tools=$(( ${total_tools} + 1))
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