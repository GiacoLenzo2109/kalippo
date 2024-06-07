#!/bin/bash

password_cracker_tools=(
    "john" 
    "hashcat" 
    "hydra" 
    "cewl"
)

function install_password_crackers() {
    CURRENT_COLOR=$PURPLE
    # Password Crackers
    category "Password Crackers"
    for tool in "${password_cracker_tools[@]}"; do
        install_tool $tool
    done
}