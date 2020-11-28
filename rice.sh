#!/bin/bash

GREEN='\033[0;32m'
MAGEN='\e[95m'
RED='ff334f'
RESET='\033[0m'

if [[ $EUID -ne 0 ]]; then
   	echo "${RED}This script must be run as root${RESET}" 
   	exit 1
else

# Functions
spinner()
{
    local pid=$!
    local delay=0.75
    local spinstr='...'
    echo "Waiting "
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf "%s  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Update
dnf upgrade -y
echo "${MAGEN}--- Updates OK ---${RESET}"
sleep 5 & spinner 

# Installing RPM fusion repos  
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Installing i3 & i3blocks
# Le fichier i3blocks.conf se trouve dans /usr/local/etc/i3blocks.conf
echo -e "${MAGEN}--- i3 install ---${RESET}"
mkdir /home/victor/i3blocks
dnf install -y autoconf automake dnf install util-linux-user
dnf install -y i3 
git clone https://github.com/vivien/i3blocks  /home/victor/.config/i3blocks
cd /home/victor/i3blocks
./autogen.sh
./configure
make
make install
sleep 10 $ spinner

# Core packages install
echo -e "${MAGEN}--- Core packages install ---${RESET}"
dnf install -y vim nmap.x86_64 keepassxc.x86_64 tmux 
dnf install -y texlive-scheme-full fontawesome-fonts.noarch lxappearance.x86_64 arc-theme
dnf install -y zathura.x86_64  zathura-pdf-mupdf.x86_64 pandoc 
dnf install -y vlc VirtualBox.x86_64  
echo -e "${MAGEN}--- Core packages install done ---${RESET}"
sleep 10 & spinner

# vscode install
echo -e "${MAGEN}--- vscode install ---${RESET}"
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update && dnf install code -y
sleep 10 & spinner

# Metasploit install
echo -e "${MAGEN}--- Metasploit install ---${RESET}"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
chmod 755 msfinstall && \
./msfinstall
sleep 3 & spinner

# Seclists install
mkdir /usr/share/listes
git clone https://github.com/danielmiessler/SecLists.git /usr/share/listes

# Gobuster install
go get github.com/OJ/gobuster
sleep 10 & spinner

# zsh configuration
dnf install zsh -y
if type -p zsh > /dev/null; then
    echo "zsh installed"
else
    echo "error while installing zsh"
fi
su -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -s /bin/sh victor 

# Reminder 
echo -e "${MAGEN}--- /!\ Installer burpsuite /!\ ---${MAGEN}"
