#!/bin/bash
# shellcheck disable=SC1090-SC1091

##################################################################################################
# Original Author: Shubham Pathak                                                                #
# Edited by: Angel Fuenmayor                                                                      #
# Description: Auto setup bash script to setup required programs after doing fresh install.      #      
##################################################################################################

c='\e[32m' # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
re='\033[0;31m' # Coloured echo (red)
r='tput sgr0' #Reset colour after echo


# Shows spinner while waiting for process to end
waitfor(){
    "$@" &>>"${0%/*}/logs.txt" &
    local PID=$!
    local i=1
    local spin="/-\|"

    echo -n " "
    while [[ -d /proc/$PID ]]; do
        local i=$(((i + 1) % ${#spin}))
        echo -ne "\b$y${spin:$i:1}"
        sleep 0.2
    done
    echo -e "\bDone"

    wait $PID
    return $?
}


#Display Banner
if command -v figlet >/dev/null 2>&1; then
    figlet AutoSetup
    echo -e "${y} - By Shubham Pathak (Edited by Angel Fuenmayor)\n"
else 
echo -e "\n\n\n\n
    _         _       ____       _
   / \  _   _| |_ ___/ ___|  ___| |_ _   _ _ __
  / _ \| | | | __/ _ \___ \ / _ \ __| | | | '_ |
 / ___ \ |_| | || (_) |__) |  __/ |_| |_| | |_) |
/_/   \_\__,_|\__\___/____/ \___|\__|\__,_| .__/
                                          |_| 
                          - By Shubham Pathak (Edited by Angel Fuenmayor)\n"
fi


# Requesting sudo permissions
echo -e "${c}Please grant ${y}sudo${c} permissions."; $r
if sudo -v -p "${y}[sudo] password for %u: "; then 
    echo -e "${c}Access Granted.\n"
    $r
else
    echo -e "${re}Sorry, this script needs sudo permissions to perform the installation."
    echo -e "${re}If your user didn't have sudo access by default, follow the next tutorial:"
    echo -e "${y}https://www.digitalocean.com/community/tutorials/how-to-create-a-new-sudo-enabled-user-on-ubuntu-22-04-quickstart"
    $r
    exit 1
fi


# Updating list of available packages
echo -ne "${c}Updating apt list of packages... "; $r
waitfor sudo apt update


# Installing nala
echo -ne "${c}Installing nala... "; $r
if command -v nala >/dev/null 2>&1; then 
    echo "${y}done."
else 
    waitfor sudo apt install -y nala
fi


# Upgrade and Update Command
echo -e "${c}Updating and upgrading before performing further operations."; $r
sudo nala fetch --auto --https-only
sudo nala update && sudo nala upgrade -y


#Installing curl and wget
echo -e "${c}Installing wget curl git zsh build-essential dnsutils net-tools neofetch"; $r
sudo nala install -y wget curl git zsh build-essential dnsutils net-tools neofetch


#Setting up Git
read -p "${y}Do you want to setup Git global config? (y/n): " -r; $r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${c}Setting up global git config at ~/.gitconfig"; $r
    git config --global color.ui auto
    read -rp "Set default branch name (main): " defaultbranch
    if [[ -z $defaultbranch ]]; then defaultbranch="main"; fi
    read -rp "Enter Your Full Name: " name
    read -rp "Enter Your Email: " email
    git config --global init.defaultBranch "$defaultbranch"
    git config --global user.name "$name"
    git config --global user.email "$email"
    echo -e "${c}Git Setup Successfully!"; $r
else
    echo -e "${c}Skipping!"; $r && :
fi

# Read list of installers
installer_list=("${0%/*}"/installers/*)

# Collecting meta data
i=1
options=()
for installer in "${installer_list[@]}";
do 
    source "$installer"
    options+=("$i" "$PACK_NAME ($PACK_CONTENT)" "off")
    i=$((i + 1))
done

# Show dialog box
dialogbox=(whiptail --separate-output --ok-button "Install" --title "Auto Setup Script" --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)
choices=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)

# Performing installations
for choice in $choices; do
    source "${installer_list[$((choice - 1))]}"
    pack-setup
done


# Final Upgrade and Update Command
echo -e "${c}Updating and upgrading to finish auto-setup script."; $r
sudo nala update && sudo nala upgrade -y
clear
neofetch
