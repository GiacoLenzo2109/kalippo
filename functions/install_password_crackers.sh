#!/bin/bash

function install_password_tools() {
    CURRENT_COLOR=$GRAY
    # Password Crackers
    category "Password Crackers"
    for tool in "${password_tools[@]}"; do
        install_tool $tool
    done
}