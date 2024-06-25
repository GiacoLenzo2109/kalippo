#!/bin/bash

# Function to print usage
function show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -a, --all                               Install all categories"
    echo "  -c, --category=category1,category2,...  Categories: network, web, seclists, kernel-exploits, privesc, password-crackers"
    echo "  -d, --directory=DIR                     Specify the installation directory"
    echo "  -h, --help                              Show this help menu"
}