#!/bin/bash

##################################################################### ENV #####################################################################

# Progress bar
source utils/progress-bar.sh
source utils/spinner.sh

# Colors
source utils/colors.sh

# Banner
source utils/banner.sh

# Help
source utils/help.sh

# Functions
source utils/check_options.sh
source utils/functions/generic.sh
source utils/functions/main.sh
source utils/functions/install_web_tools.sh
source utils/functions/install_seclists.sh
source utils/functions/install_kernel_exploits.sh
source utils/functions/install_privesc.sh
source utils/functions/install_password_crackers.sh
source utils/functions/install_pivoting.sh
source utils/functions/install_network_tools.sh

##################################################################### RUN #####################################################################

set_spinner "spinner1"
show_banner

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--directory=*)
            INSTALL_DIR="${1#*=}"
            shift
            ;;
        -d|--directory)
            INSTALL_DIR="$2"
            shift 2
            ;;
        --category=*)
            PACKAGES="${1#*=}"
            verify_packages
            shift
            ;;
        -c)
            PACKAGES="$2"
            verify_packages
            shift 2
            ;;
        -P|--patatona)
            patatona
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown parameter passed: $1"
            show_help
            exit 1
            ;;
    esac
done

verify_packages

# Set default installation directory if not provided
if [[ -z $INSTALL_DIR ]]; then
    INSTALL_DIR="$HOME/Tools"
fi

setup_env $INSTALL_DIR

# Output the installation directory
echo "> Installation directory: $INSTALL_DIR"

# Output the categories if specified
if [[ ${#PACKAGES_ARRAY[@]} -gt 0 ]]; then
    echo "> Categories: ${PACKAGES_ARRAY[@]}"
    # for category in "${PACKAGES_ARRAY[@]}"; do
    #     echo "Category: $category"
    # done
fi

update_package_lists

install_packages


# Clear loading bar
echo -ne "\r$(tput el)"
echo "All tools installed successfully!"