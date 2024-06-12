#!/bin/bash

function check_distro() {
    if not which apt &> /dev/null; then
        echo "You are not using a supported Distro."
        echo "Download Kali Linux from https://www.kali.org/downloads/"
        echo ""
        echo "Exiting..."
        exit 0
    fi

    if ! grep -q "kali" /etc/apt/sources.list; then
        echo "-> Adding Kali repository"
        echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list.d/kali.list
    fi
}