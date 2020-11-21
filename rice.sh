#!/bin/bash

GREEN='\033[0;32m'
MAGEN='\e[95m'
RESET='\033[0m'

# Mise a jour
dnf upgrade -y
echo "${MAGEN}--- Mises a jour terminee ---${RESET}"
sleep 10

# Installation des repertoires RPM fusion 
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Installation des packages lies a i3
# Le fichier i3blocks.conf se trouve dans /usr/local/etc/i3blocks.conf
echo -e "${MAGEN}--- Installation de i3 ---${RESET}"
dnf install autoconf automake -y
dnf install i3 -y
git clone https://github.com/vivien/i3blocks
cd i3blocks
./autogen.sh
./configure
make
make install
sleep 10 


# Installation des packages 
echo -e "${MAGEN}--- Installation des packages de base ---${RESET}"
dnf install vim nmap.x86_64 keepassxc.x86_64 tmux -y
dnf install texlive-scheme-full -y
dnf install fontawesome-fonts.noarch -y
dnf install lxappearance.x86_64 arc-theme -y 
dnf install zathura.x86_64  zathura-pdf-mupdf.x86_64 -y
dnf install pandoc -y
dnf install vlc VirtualBox.x86_64  -y
echo -e "${MAGEN}--- Installation des packages de base terminee ---${RESET}"
sleep 10


# Installation de vscode
echo -e "${MAGEN}--- Installation de vscode ---${RESET}"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf check-update && dnf install code -y
sleep 10

# Installation de Metasploit
echo -e "${MAGEN}--- Installation de metasploit ---${RESET}"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
chmod 755 msfinstall && \
./msfinstall

# Configuration de zsh
dnf install util-linux-user -y
dnf install zsh -y
if type -p zsh > /dev/null; then
    echo "zsh installe"
else
    echo "erreur d'installation de zsh"
fi
#chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Rappel 
echo -e "${MAGEN}--- /!\ Installer burpsuite /!\ ---${MAGEN}"
echo -e "${MAGEN}--- /!\ Installer gobuster /!\ ---${MAGEN}"
echo -e "${MAGEN}--- /!\ Installer dictionnaires seclists /!\ ---${MAGEN}"