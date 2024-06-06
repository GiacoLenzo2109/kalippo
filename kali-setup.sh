#!/bin/bash
# Download and install tools

################################################################### Spinner ###################################################################
declare -x FRAME
declare -x FRAME_INTERVAL

set_spinner() {
  case $1 in
    spinner1)
      FRAME=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
      FRAME_INTERVAL=0.1
      ;;
    spinner2)
      FRAME=("-" "\\" "|" "/")
      FRAME_INTERVAL=0.25
      ;;
    spinner3)
      FRAME=("◐" "◓" "◑" "◒")
      FRAME_INTERVAL=0.5
      ;;
    *)
      echo "No spinner is defined for $1"
      exit 1
  esac
}

function start_spinner() {
  local step=0

  tput civis

    while ps -p "$!" &>/dev/null; do
        echo -ne "\\r[   ] Installing $1..."
        for k in "${!FRAME[@]}"; do
        echo -ne "\\r[ ${FRAME[k]} ]"
        sleep $FRAME_INTERVAL
        done
    done

    echo -ne "\\r[ ✔ ] Installed $1\\n"
    current_tool=$((current_tool+1))
    draw_progress_bar $current_tool

  tput cnorm
}

set_spinner "spinner1"


################################################################### Progress ###################################################################
# Constants
CODE_SAVE_CURSOR="\033[s"
CODE_RESTORE_CURSOR="\033[u"
CODE_CURSOR_IN_SCROLL_AREA="\033[1A"
COLOR_FG="\e[30m"
COLOR_BG="\e[42m"
COLOR_BG_BLOCKED="\e[43m"
RESTORE_FG="\e[39m"
RESTORE_BG="\e[49m"

# Variables
PROGRESS_BLOCKED="false"
TRAPPING_ENABLED="false"
ETA_ENABLED="false"
TRAP_SET="false"

CURRENT_NR_LINES=0
PROGRESS_TITLE=""
PROGRESS_TOTAL=100
PROGRESS_START=0
BLOCKED_START=0

# shellcheck disable=SC2120
setup_scroll_area() {
    # If trapping is enabled, we will want to activate it whenever we setup the scroll area and remove it when we break the scroll area
    if [ "$TRAPPING_ENABLED" = "true" ]; then
        trap_on_interrupt
    fi

    # Handle first parameter: alternative progress bar title
    [ -n "$1" ] && PROGRESS_TITLE="$1" || PROGRESS_TITLE="Progress"

    # Handle second parameter : alternative total count
    [ -n "$2" ] && PROGRESS_TOTAL=$2 || PROGRESS_TOTAL=100

    lines=$(tput lines)
    CURRENT_NR_LINES=$lines
    lines=$((lines-1))
    # Scroll down a bit to avoid visual glitch when the screen area shrinks by one row
    echo -en "\n"

    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"
    # Set scroll region (this will place the cursor in the top left)
    echo -en "\033[0;${lines}r"

    # Restore cursor but ensure its inside the scrolling area
    echo -en "$CODE_RESTORE_CURSOR"
    echo -en "$CODE_CURSOR_IN_SCROLL_AREA"

    # Store start timestamp to compute ETA
    if [ "$ETA_ENABLED" = "true" ]; then
      PROGRESS_START=$( date +%s )
    fi

    # Start empty progress bar
    draw_progress_bar 0
}

destroy_scroll_area() {
    lines=$(tput lines)
    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"
    # Set scroll region (this will place the cursor in the top left)
    echo -en "\033[0;${lines}r"

    # Restore cursor but ensure its inside the scrolling area
    echo -en "$CODE_RESTORE_CURSOR"
    echo -en "$CODE_CURSOR_IN_SCROLL_AREA"

    # We are done so clear the scroll bar
    clear_progress_bar

    # Scroll down a bit to avoid visual glitch when the screen area grows by one row
    echo -en "\n\n"

    # Reset title for next usage
    PROGRESS_TITLE=""

    # Once the scroll area is cleared, we want to remove any trap previously set. Otherwise, ctrl+c will exit our shell
    if [ "$TRAP_SET" = "true" ]; then
        trap - EXIT
    fi
}

format_eta() {
    local T=$1
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    [ $D -eq 0 -a $H -eq 0 -a $M -eq 0 -a $S -eq 0 ] && echo "--:--:--" && return
    [ $D -gt 0 ] && printf '%d days, ' $D
    printf 'ETA: %d:%02.f:%02.f' $H $M $S
}

draw_progress_bar() {
    eta=""
    if [ "$ETA_ENABLED" = "true" -a $1 -gt 0 ]; then
        if [ "$PROGRESS_BLOCKED" = "true" ]; then
            blocked_duration=$(($(date +%s)-$BLOCKED_START))
            PROGRESS_START=$((PROGRESS_START+blocked_duration))
        fi
        running_time=$(($(date +%s)-PROGRESS_START))
        total_time=$((PROGRESS_TOTAL*running_time/$1))
        eta=$( format_eta $(($total_time-$running_time)) )
    fi

    percentage=$1
    if [ $PROGRESS_TOTAL -ne 100 ]
    then
	[ $PROGRESS_TOTAL -eq 0 ] && percentage=100 || percentage=$((percentage*100/$PROGRESS_TOTAL))
    fi
    extra=$2

    lines=$(tput lines)
    lines=$((lines))

    # Check if the window has been resized. If so, reset the scroll area
    if [ "$lines" -ne "$CURRENT_NR_LINES" ]; then
        setup_scroll_area
    fi

    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"

    # Move cursor position to last row
    echo -en "\033[${lines};0f"

    # Clear progress bar
    tput el

    # Draw progress bar
    PROGRESS_BLOCKED="false"
    print_bar_text $percentage "$extra" "$eta"

    # Restore cursor position
    echo -en "$CODE_RESTORE_CURSOR"
}

block_progress_bar() {
    percentage=$1
    lines=$(tput lines)
    lines=$((lines))
    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"

    # Move cursor position to last row
    echo -en "\033[${lines};0f"

    # Clear progress bar
    tput el

    # Draw progress bar
    PROGRESS_BLOCKED="true"
    BLOCKED_START=$( date +%s )
    print_bar_text $percentage

    # Restore cursor position
    echo -en "$CODE_RESTORE_CURSOR"
}

clear_progress_bar() {
    lines=$(tput lines)
    lines=$((lines))
    # Save cursor
    echo -en "$CODE_SAVE_CURSOR"

    # Move cursor position to last row
    echo -en "\033[${lines};0f"

    # clear progress bar
    tput el

    # Restore cursor position
    echo -en "$CODE_RESTORE_CURSOR"
}

print_bar_text() {
    local percentage=$1
    local extra=$2
    [ -n "$extra" ] && extra=" ($extra)"
    local eta=$3
    if [ -n "$eta" ]; then
        [ -n "$extra" ] && extra="$extra "
        extra="$extra$eta"
    fi
    local cols=$(tput cols)
    bar_size=$((cols-9-${#PROGRESS_TITLE}-${#extra}))

    local color="${COLOR_FG}${COLOR_BG}"
    if [ "$PROGRESS_BLOCKED" = "true" ]; then
        color="${COLOR_FG}${COLOR_BG_BLOCKED}"
    fi

    # Prepare progress bar
    complete_size=$(((bar_size*percentage)/100))
    remainder_size=$((bar_size-complete_size))
    progress_bar=$(echo -ne "["; echo -en "${color}"; printf_new "#" $complete_size; echo -en "${RESTORE_FG}${RESTORE_BG}"; printf_new "." $remainder_size; echo -ne "]");

    # Print progress bar
    echo -ne " $PROGRESS_TITLE ${percentage}% ${progress_bar}${extra}"
}

enable_trapping() {
    TRAPPING_ENABLED="true"
}

trap_on_interrupt() {
    # If this function is called, we setup an interrupt handler to cleanup the progress bar
    TRAP_SET="true"
    trap cleanup_on_interrupt EXIT
}

cleanup_on_interrupt() {
    destroy_scroll_area
    exit
}

printf_new() {
    str=$1
    num=$2
    v=$(printf "%-${num}s" "$str")
    echo -ne "${v// /$str}"
}

##################################################################### ENV #####################################################################

GREEN="32m"
YELLOW="33m"
BLUE="34m"
PURPLE="35m"
CYAN="36m"
WHITE="37m"

function echo_bold() {
    echo -e "\e[1;$CURRENT_COLOR$1\e[0m"
}

function category() {
    echo_bold "[ * ] $1"
}

function subcategory() {
    echo_bold "|"
    echo_bold "[ * ][ * ] $1"
}


#################################################################### Tools ####################################################################

function setup_env() {
    mkdir $HOME/Tools > /dev/null 2>&1
    cd $HOME/Tools > /dev/null 2>&1
}

function folder() {
    mkdir $HOME/Tools/$1 > /dev/null 2>&1
    cd $HOME/Tools/$1 > /dev/null 2>&1
}

# Function to install a tool
function install_tool() {
    tool_name=$1
    sudo apt-get install -y $tool_name > /dev/null 2>&1 & start_spinner $tool_name
}

function install_tool_pip() {
    tool_name=$1
    pip install $tool_name > /dev/null 2>&1 & start_spinner $tool_name
}

function install_tool_pipx() {
    tool_name=$1
    pipx install $2 > /dev/null 2>&1 & start_spinner $tool_name
}

function download_tool() {
    tool_name=$1
    wget $2 > /dev/null 2>&1 & start_spinner $tool_name
}

# Update package lists
function update_package_lists() {
    echo "Updating package lists..."
    sudo apt-get update > /dev/null 2>&1
}

function pipx_install() {
    sudo apt install python3-venv  > /dev/null 2>&1
    python3 -m pip install --user pipx  > /dev/null 2>&1 & start_spinner "pipx"
    python3 -m pipx ensurepath  > /dev/null 2>&1
}

# Install tools
web_tools=("feroxbuster" "dirsearch" "ffuf" "gobuster" "wpscan" "sqlmap" "burpsuite")
seclists=("seclists")
password_cracker_tools=("john" "hashcat" "hydra" "cewl")
network_tools=("dnsrecon" "enum4linux" "nikto" "bloodhound" "bloodhound.py" "mimikatz" "pypykatz" "crackmapexec" "impacket-scripts" "evil-winrm")

total_tools=$(( ${#web_tools[@]} + ${#seclists[@]} + ${#password_cracker_tools[@]} + ${#network_tools[@]} + 22))
current_tool=0

update_package_lists

function install_network_tools() {
    CURRENT_COLOR=$CYAN

    category "Network Tools"

    # Recon Tools
    subcategory "Recon Tools"
    folder "Recon"

    # NmapAutomator
    git clone https://github.com/21y4d/nmapAutomator.git > /dev/null 2>&1
    sudo ln -s $(pwd)/nmapAutomator/nmapAutomator.sh /usr/local/bin/ > /dev/null 2>&1 & start_spinner "nmapAutomator"

    # AutoRecon
    sudo apt install seclists curl dnsrecon enum4linux feroxbuster gobuster impacket-scripts nbtscan nikto nmap onesixtyone oscanner redis-tools smbclient smbmap snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf > /dev/null 2>&1  & start_spinner "AutoRecon Dependencies"
    install_tool_pipx "AutoRecon" "git+https://github.com/Tib3rius/AutoRecon.git"

    folder "Network"

    # Windows AD Tools
    subcategory "Windows Tools"
    folder "Network/Windows"

    download_tool "PowerSploit" "https://github.com/PowerShellMafia/PowerSploit/archive/refs/tags/v3.0.0.zip"
    unzip v3.0.0.zip > /dev/null 2>&1
    rm v3.0.0.zip > /dev/null 2>&1

    download_tool "Mimikatz" "https://raw.githubusercontent.com/ParrotSec/mimikatz/master/x64/mimikatz.exe"

    download_tool "Rubeus" "https://raw.githubusercontent.com/r3motecontrol/Ghostpack-CompiledBinaries/master/Rubeus.exe"

    download_tool "LaZagne" "https://github.com/AlessandroZ/LaZagne/releases/download/v2.4.5/LaZagne.exe"

    # Linux
    subcategory "Linux Tools"
    folder "Network/Linux"

    # NetExec
    install_tool_pipx "NetExec" "git+https://github.com/Pennyw0rth/NetExec"

    # Others
    for tool in "${network_tools[@]}"; do
        install_tool $tool
    done
}

function install_web_tools() {
    CURRENT_COLOR=$GREEN
    # Dirbusting Tools
    echo_bold "[ * ] Web Tools"
    pip install wfuzz > /dev/null 2>&1 & start_spinner "wfuzz"
    for tool in "${web_tools[@]}"; do
        install_tool $tool
    done
}

function install_seclists() {
    CURRENT_COLOR=$YELLOW
    # Seclists 
    mkdir $HOME/Tools/SecLists > /dev/null 2>&1
    cd $HOME/Tools/SecLists > /dev/null 2>&1

    echo_bold "[ * ] Seclists"
    for tool in "${seclists[@]}"; do
        install_tool $tool
    done
}

function install_kernel_exploits() {
    CURRENT_COLOR=$BLUE
    # Kernel Exploits
    mkdir $HOME/Tools/KernelExploits > /dev/null 2>&1
    cd $HOME/Tools/KernelExploits > /dev/null 2>&1

    echo_bold "[ * ] Kernel Exploits"

    # Windows Kernel Exploits
    echo_bold "|"
    echo_bold "[ * ][ * ] Windows Kernel Exploits"
    mkdir $HOME/Tools/KernelExploits/Windows > /dev/null 2>&1
    cd $HOME/Tools/KernelExploits/Windows > /dev/null 2>&1

    git clone https://github.com/SecWiki/windows-kernel-exploits.git . > /dev/null 2>&1 & start_spinner "Windows Kernel Exploits"

    # Linx Kernel Exploits
    echo_bold "|"
    echo_bold "[ * ][ * ] Linux Kernel Exploits"
    mkdir $HOME/Tools/KernelExploits/Linux > /dev/null 2>&1
    cd $HOME/Tools/KernelExploits/Linux > /dev/null 2>&1
    
    git clone https://github.com/lucyoa/kernel-exploits.git . > /dev/null 2>&1 & start_spinner "Linux Kernel Exploits"
}

function install_password_crackers() {
    CURRENT_COLOR=$PURPLE
    # Password Crackers
    echo_bold "[ * ] Password Crackers"
    for tool in "${password_cracker_tools[@]}"; do
        install_tool $tool
    done
}

function install_privesc() {
    CURRENT_COLOR=$CYAN
    # Privesc
    echo_bold "[ * ] Privesc"
    mkdir $HOME/Tools/Privesc > /dev/null 2>&1
    cd $HOME/Tools/Privesc > /dev/null 2>&1

    # Windows Privesc
    mkdir $HOME/Tools/Privesc/Windows > /dev/null 2>&1
    cd $HOME/Tools/Privesc/Windows > /dev/null 2>&1
    echo_bold "|"
    echo_bold "[ * ][ * ] Windows Privesc"

    pip install wesng > /dev/null 2>&1
    git clone https://github.com/bitsadmin/wesng --depth 1 > /dev/null 2>&1 & start_spinner "Wesng"

    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240602-829055f0/winPEASx64.exe > /dev/null 2>&1
    wget https://github.com/peass-ng/PEASS-ng/releases/download/20240602-829055f0/winPEASx86.exe > /dev/null 2>&1 & start_spinner "WinPEAS"

    wget  https://raw.githubusercontent.com/411Hall/JAWS/master/jaws-enum.ps1 > /dev/null 2>&1 & start_spinner "JAWS"

    wget https://github.com/itm4n/PrintSpoofer/releases/download/v1.0/PrintSpoofer64.exe > /dev/null 2>&1 & start_spinner "PrintSpoofer64"
    wget https://github.com/antonioCoco/RoguePotato/releases/download/1.0/RoguePotato.zip && unzip RoguePotato.zip > /dev/null 2>&1 & start_spinner "RoguePotato"
    wget https://github.com/jakobfriedl/precompiled-binaries/raw/main/Token/SharpEfsPotato.exe > /dev/null 2>&1 & start_spinner "SharpEfsPotato"
    wget https://github.com/jakobfriedl/precompiled-binaries/raw/main/Token/JuicyPotato.exe > /dev/null 2>&1 & start_spinner "JuicyPotato"
    wget https://github.com/jakobfriedl/precompiled-binaries/raw/main/Token/GodPotato.exe > /dev/null 2>&1 & start_spinner "GodPotato"

    # Linux Privesc
    mkdir $HOME/Tools/Privesc/Linux
    cd $HOME/Tools/Privesc/Linux
    echo_bold "|"
    echo_bold "[ * ][ * ] Linux Privesc"

    wget https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh > /dev/null 2>&1 & start_spinner "Linxu Exploit Suggester"

    wget https://github.com/rebootuser/LinEnum/blob/master/LinEnum.sh > /dev/null 2>&1 & start_spinner "LinEnum"

    wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh > /dev/null 2>&1 & start_spinner "LinPEAS"
}

function install_pivoting() {
    CURRENT_COLOR=$GREEN
    #Pivoting
    echo_bold "[ * ] Pivoting"
    mkdir $HOME/Tools/Pivoting
    cd $HOME/Tools/Pivoting

    # Chisel
    wget https://github.com/jpillora/chisel/releases/download/v1.9.1/chisel_1.9.1_linux_amd64.gz > /dev/null 2>&1 && gzip -d chisel_1.9.1_linux_amd64.gz && rm chisel_1.9.1_linux_amd64.gz > /dev/null 2>&1 & start_spinner "Chisel"
}

function run() {
    enable_trapping
    setup_scroll_area "Progress" $total_tools

    setup_env
    install_network_tools
    install_web_tools
    install_seclists
    install_kernel_exploits
    install_privesc
    install_password_crackers
    install_pivoting

    destroy_scroll_area
}

run


# Clear loading bar
echo -ne "\r$(tput el)"
echo "All tools installed successfully!"