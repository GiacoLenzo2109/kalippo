#!/bin/bash

function install_caido() {
    CURRENT_COLOR=$GRAY
    # Proxy Tools
    category "Proxy Tools"
    if [[ $(uname -m) == "x86_64" ]]; then
        download_tool "Caido" "https://caido.download/releases/v0.47.1/caido-desktop-v0.47.1-linux-x86_64.deb"
    elif [[ $(uname -m) == "arm64" ]]; then
        download_tool "Caido" "https://caido.download/releases/v0.47.1/caido-desktop-v0.47.1-linux-aarch64.deb"
    else
        echo "Unknown architecture: $(uname -m)"
    fi
    if [[ -f "caido-desktop-v0.47.1-linux-x86_64.deb" || -f "caido-desktop-v0.47.1-linux-aarch64.deb" ]]; then
        sudo dpkg -i caido-desktop-v0.47.1-linux-*.deb
        rm caido-desktop-v0.47.1-linux-*.deb
    else
        echo "Caido installation failed."
    fi
}