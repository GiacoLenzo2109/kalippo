#!/bin/bash

function check_distro() {
    if ! which apt &> /dev/null; then
        echo "You are not using a supported Debian-based distribution."
        echo "Your current distribution is $(head /etc/os-release -n 1 | awk -F '\"' '{ print $2 }' | sed 's/\"//g')"
        echo ""
        echo "Exiting..."
        exit 0
    fi

    if ! grep -q "kali" /etc/apt/sources.list; then
        echo "-> Adding Kali repository"
        echo "deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list.d/kali.list
    fi
}