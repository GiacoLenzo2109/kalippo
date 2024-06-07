#!/bin/bash

# Function to verify and convert packages to array
function verify_packages() {
    valid_categories=("network" "web" "seclists" "kernel-exploits" "privesc" "password-crackers")
    IFS=',' read -r -a PACKAGES_ARRAY <<< "$PACKAGES"
    for category in "${PACKAGES_ARRAY[@]}"; do
        if [[ ! " ${valid_categories[*]} " =~ " $category " ]]; then
            echo "Invalid category: $category"
            echo "Possible categories: ${valid_categories[*]}"
            exit 1
        fi
    done
}

# Function to print patatona
function patatona() {
    echo "patatona"
}