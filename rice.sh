#!/bin/bash

GREEN='\033[0;32m'
MAGEN='\e[95m'
RED='ff334f'
RESET='\033[0m'

if ! [ $(id -u) = 0 ]; then
   echo "I am not root!"
   exit 1
fi

# Functions
function pause {
yes | pv -SpeL1 -s 10 > /dev/null
}

# Update
dnf upgrade -y 
echo -e "${MAGEN}--- Updates OK ---${RESET}"

# Installing RPM fusion repos  
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Core packages install
echo -e "${MAGEN}--- Core packages install ---${RESET}"
dnf install -y autoconf automake util-linux-user
dnf install -y pv vim nmap.x86_64 keepassxc.x86_64 tmux 
dnf install -y texlive-scheme-full fontawesome-fonts.noarch lxappearance.x86_64 arc-theme
dnf install -y zathura.x86_64  zathura-pdf-mupdf.x86_64 pandoc 
dnf install -y vlc VirtualBox.x86_64  
echo -e "${MAGEN}--- Core packages install done ---${RESET}"
pause

# Installing i3 & i3blocks
# Le fichier i3blocks.conf se trouve dans /usr/local/etc/i3blocks.conf
echo -e "${MAGEN}--- i3 install ---${RESET}"
mkdir /home/victor/.config/i3blocks
dnf install -y i3 
git clone https://github.com/vivien/i3blocks  /home/victor/.config/i3blocks
cd /home/victor/.config/i3blocks
sh autogen.sh
sh configure
make
make install
pause

# vscode install
echo -e "${MAGEN}--- vscode install ---${RESET}"
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update && dnf install code -y
pause

# Metasploit install
echo -e "${MAGEN}--- Metasploit install ---${RESET}"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
chmod 755 msfinstall && \
sh msfinstall
pause

# Seclists install
mkdir /usr/share/listes
git clone https://github.com/danielmiessler/SecLists.git /usr/share/listes

# Gobuster install
go get github.com/OJ/gobuster
pause

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
