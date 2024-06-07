#!/bin/bash

# Function to print usage
function show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -d, --directory=DIR                     Specify the installation directory"
    echo "  -c, --category=category1,category2,...  Specify the packages' categories to install"
    echo "                                          Possible categories: network, web, seclists,"
    echo "                                          kernel-exploits, privesc, password-crackers"
    echo "  -P, --patatona                          Print patatona"
    echo "  -h, --help                              Show this help menu"
}