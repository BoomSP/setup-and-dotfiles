#!/usr/bin/env bash

echo "[ ] Repository Update"
sudo apt update
sudo apt -y upgrade

# Google Chrome Installtion
echo "[ ] Download and Install Google Chrome"

chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
chrome_deb=$(echo "${chrome_url}" | rev | cut -d'/' -f 1 | rev)

# Dependency
sudo apt install -y libu2f-udev
wget -O ~/Downloads/"${chrome_deb}" "${chrome_url}"
sudo dpkg -i ~/Downloads/"${chrome_deb}"
rm "${chrome_deb}"
echo "[+] Google Chrome Installed"

# Unzip rockyou.txt
echo "[ ] Prepare rockyou.txt"
rockyou_path="/usr/share/wordlists/rockyou.txt.gz"
sudo gzip -d "${rockyou_path}"

# Seclists Installation
echo "[ ] Install seclists"
sudo apt install -y seclists

# Neovim Installation
echo "[ ] Install Neovim"
echo "[ ] Vim will trigger Neovim instead"
sudo apt install -y neovim
echo "alias vim=\"nvim\"" | tee -a ~/.zshrc
source ~/.zshrc
git config --global core.editor nvim

echo "Install tools"
sudo apt install -y feroxbuster
sudo apt install -y npm
sudo apt install -y openssh-server
sudo apt install -y openjdk-11-jdk

# Metasploit
echo "[ ] Setup Metasploit"
sudo msfdb init
sudo systemctl enable postgresql

echo "[ ] Setup Neo4j and BloodHound"
sudo apt install -y neo4j
sudo neo4j start
echo "[!] Please set up Neo4j password by yourself"
sudo apt install -y bloodhound

# Docker Installation
echo "Install Docker"
sudo apt install -y docker.io
sudo systemctl enable docker --now

sudo usermod -aG docker $USER

# Other tools form GitHub
mkdir ~/tools
export PATH=~/tools:$PATH

# Get ysoserial
ysoserial_url="https://github.com/frohoff/ysoserial/releases/download/v0.0.6/ysoserial-all.jar"
ysoserial_jar=$(echo "${ysoserial_url}" | rev | cut -d'/' -f 1 | rev)
wget -O ~/tools/"${ysoserial_jar}" "${ysoserial_url}"
mv ~/tools/"$ysoserial_jar" ~/tools/ysoserial.jar

# Setup minimal nvim
nvim_init_url="https://raw.githubusercontent.com/BoomSP/setup-and-dotfiles/main/init.nvim"
mkdir -p ~/.config/nvim
wget -O ~/.config/nvim/init.vim "${nvim_init_url}"

# Install pip2
pip2_url="https://bootstrap.pypa.io/pip/2.7/get-pip.py"
pip2_py=$(echo "${pip2_url}" | rev | cut -d'/' -f 1 | rev)
wget -O ~/Downloads/"${pip2_py}" "${pip2_url}"
sudo python2 ~/Downloads/"${pip2_py}"
pip2 install --upgrade setuptools
sudo apt install -y python2.7-dev
rm ~/Downloads/"${pip2_py}"

sudo apt -y autoremove

echo "[!] For Hyper-V need to install Enhanced Session Mode by $ kali-tweaks"
echo "[!] On PowerShell as admin: PS> Set-VM $(hostname) -EnhancedSessionTransportType HVSocket"
# Docker needs user to logout and login again
echo "[!] Please logout and login again"