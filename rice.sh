#!/bin/bash

GREEN='\033[0;32m'
RESET='\033[0m'

# Configuration de zsh
dnf install zsh -y
if type -p zsh > /dev/null; then
    echo "zsh installe"
else
    echo "erreur d'installation de zsh"
fi

chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
dnf upgrade -y

# Installation des packages
echo -e "${GREEN}--- Installation de i3 et i3-blocks ---${RESET}"
dnf install i3 i3-blocks -y

echo -e "${GREEN}--- Installation des packages de base ---${RESET}"
nmap keepassxc tmux zathura vlc virtualbox -y

# Installation de vscode
echo -e "${GREEN}--- Installation de vscode ---${RESET}"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf check-update && dnf install code -y

# Installation de Metasploit
echo -e "${GREEN}--- Installation de metasploit ---${RESET}"
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
