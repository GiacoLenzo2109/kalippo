#!/bin/bash

LIGOLO_VERSION="0.5.2"
CHISEL_VERSION="1.9.1"

function install_ligolo() {
    # Ligolo
    folder "Tunneling/Ligolo"
    download_tool "Ligolo Proxy Linux" "https://github.com/nicocha30/ligolo-ng/releases/download/v${LIGOLO_VERSION}/ligolo-ng_proxy_${LIGOLO_VERSION}_linux_amd64.tar.gz" && tar xvf ligolo-ng_proxy_${LIGOLO_VERSION}_linux_amd64.tar.gz > /dev/null 2>&1 && rm ligolo-ng_proxy_${LIGOLO_VERSION}_linux_amd64.tar.gz
    download_tool "Ligolo Agent Linux" "https://github.com/nicocha30/ligolo-ng/releases/download/v${LIGOLO_VERSION}/ligolo-ng_agent_${LIGOLO_VERSION}_linux_amd64.tar.gz" && tar xvf ligolo-ng_agent_${LIGOLO_VERSION}_linux_amd64.tar.gz > /dev/null 2>&1 && rm ligolo-ng_agent_${LIGOLO_VERSION}_linux_amd64.tar.gz
    download_tool "Ligolo Agent Windows" "https://github.com/nicocha30/ligolo-ng/releases/download/v${LIGOLO_VERSION}/ligolo-ng_agent_${LIGOLO_VERSION}_windows_amd64.zip" && unzip -o ligolo-ng_agent_${LIGOLO_VERSION}_windows_amd64.zip > /dev/null 2>&1 && rm ligolo-ng_agent_${LIGOLO_VERSION}_windows_amd64.zip
    download_tool "Ligolo Proxy Windows" "https://github.com/nicocha30/ligolo-ng/releases/download/v${LIGOLO_VERSION}/ligolo-ng_proxy_${LIGOLO_VERSION}_windows_amd64.zip" && unzip -o ligolo-ng_proxy_${LIGOLO_VERSION}_windows_amd64.zip > /dev/null 2>&1 && rm ligolo-ng_proxy_${LIGOLO_VERSION}_windows_amd64.zip
}

function install_chisel() {
    folder "Tunneling/Chisel"
    download_tool "Chisel Linux" "https://github.com/jpillora/chisel/releases/download/v${CHISEL_VERSION}/chisel_${CHISEL_VERSION}_linux_amd64.gz" && gzip -d chisel_${CHISEL_VERSION}_linux_amd64.gz > /dev/null 2>&1
    download_tool "Chisel Windows" "https://github.com/jpillora/chisel/releases/download/v${CHISEL_VERSION}/chisel_${CHISEL_VERSION}_windows_amd64.gz" && gzip -d chisel_${CHISEL_VERSION}_windows_amd64.gz > /dev/null 2>&1
}

function install_tunneling() {
    CURRENT_COLOR=$GREEN
    #Pivoting
    category "Tunneling"
    folder "Tunneling"

    #Ligolo
    install_ligolo

    # Chisel
    install_chisel
}