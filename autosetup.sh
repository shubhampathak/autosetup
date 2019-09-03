#!/bin/bash

##################################################################################################
# Author: Shubham Pathak                                                                         # 
# Description: Auto setup bash script to setup required programs after doing fresh install.      # 
# Tested against Debian based distributions like Ubuntu 16.04/18.04 and Kali Linux.              #        
##################################################################################################

c='\e[32m' # Coloured echo (Green)
r='tput sgr0' #Reset colour after echo

# Required dependencies for all softwares (important)
echo -e "${c}Installing complete dependencies pack."; $r
sudo apt install -y software-properties-common apt-transport-https build-essential checkinstall libreadline-gplv2-dev libxssl libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev autoconf automake libtool make g++ unzip flex bison gcc libssl-dev libyaml-dev libreadline6-dev zlib1g zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev libpq-dev libpcap-dev libmagickwand-dev libappindicator3-1 libindicator3-7 imagemagick xdg-utils

# Show Battery Percentage on Top Bar [Debian (gnome)]
if [ $XDG_CURRENT_DESKTOP == 'GNOME' ]; then
	gsettings set org.gnome.desktop.interface show-battery-percentage true
fi

# Upgrade and Update Command
echo -e "${c}Updating and upgrading before performing further operations."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y

#Snap Installation & Setup
echo -e "${c}Installing Snap & setting up."; $r
sudo apt install -y snapd
sudo systemctl start snapd
sudo systemctl enable snapd
sudo systemctl start apparmor
sudo systemctl enable apparmor
export PATH=$PATH:/snap/bin
sudo snap refresh

#Setting up Git
read -p "${c}Do you want to setup Git global config? (y/n): " -r; $r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${c}Setting up Git"; $r
	(set -x; git --version )
	echo -e "${c}Setting up global git config at ~/.gitconfig"; $r
	git config --global color.ui true
	read -p "Enter Your Full Name: " name
	read -p "Enter Your Email: " email
	git config --global user.name "$name"
	git config --global user.email "$email"
	echo -e "${c}Git Setup Successfully!"; $r
else
	echo -e "${c}Skipping!"; $r && :
fi

#Installing curl and wget
echo -e "${c}Installing Curl and wget"; $r
sudo apt-get install -y wget curl

#Installing dig
echo -e "${c}Installing DNS Utils"; $r
sudo apt install -y dnsutils

#Installing ADB and Fastboot
echo -e "${c}Installing ADB and Fastboot"; $r
sudo apt install -y android-tools-adb android-tools-fastboot

#Creating Directory Inside $HOME
echo -e "${c}Creating Directory named 'tools' inside $HOME directory."; $r
cd
mkdir tools

#Downloading SecLists
read -p "${c}Do you want to download Daniel Miessler's SecLists (quite useful during recon)?: " -r; $r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "${c}Downloading SecLists in $HOME/tools"; $r
	cd && cd tools 
	git clone --depth 1 https://github.com/danielmiessler/SecLists.git
else
 	echo -e "${c}Skipping!"; $r && :
fi

#Executing Install Dialog
dialogbox=(whiptail --separate-output --ok-button "Install" --title "Auto Setup Script" --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)
options=(1 "Visual Studio Code" off
		 2 "Python2 and iPython" off
		 3 "Python3" off
		 4 "Go" off
		 5 "Rbenv" off
		 6 "JRE & JDK" off
		 7 "Masscan" off
		 8 "Chrome" off
		 9 "NMAP" off
		 10 "Drozer Framework" off
		 11 "Jadx" off
		 12 "Ettercap" off
		 13 "SQLMAP" off
		 14 "Yara" off
		 15 "i3 Window Manager" off
		 16 "EyeWitness" off
		 17 "Skype" off
		 18 "NodeJS" off
		 19 "Sublime Text 3" off
		 20 "Wireshark" off
         21 "Amass" off
         22 "Knockpy" off
         23 "Dirsearch" off
         24 "LinkFinder" off
         25 "Virtual Box" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choices in $selected
do
	case $choices in
		1) 
		echo -e "${c}Installing Visual Studio Code"; $r
		curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
		sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
		sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
		sudo apt update -y
		sudo apt install -y code
                sudo rm -f microsoft.gpg
		echo -e "${c}Visual Studio Code Installed Successfully."; $r
		;;

		2) 
		echo -e "${c}Installing Python2 and iPython"; $r
		sudo apt install -y python-pip
		( set -x ; pip --version )
		sudo pip install ipython
		;;

		3) 
		echo -e "${c}Installing Python3"; $r
		( set -x ; sudo add-apt-repository ppa:deadsnakes/ppa -y )
		sudo apt install -y python3
		( set -x ; python3 --version )
		;;

		4) 
		echo -e "${c}Installing Go version 1.12.9"; $r #Change the version if you want.
		cd
		wget https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
		sudo tar -C /usr/local -xzf go1.12.9.linux-amd64.tar.gz
		sudo rm -f go1.12.9.linux-amd64.tar.gz
		echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
		source ~/.profile
		echo -e "${c}Verifying Go Installation"; $r
		( set -x ; go version )
		echo -e "${c}Go Installed Successfully."; $r
		;;

		5) 
		echo -e "${c}Installing & Setting up rbenv"; $r
		cd
		sudo rm -rf .rbenv/
		git clone https://github.com/rbenv/rbenv.git ~/.rbenv
		echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
		echo 'eval "$(rbenv init -)"' >> ~/.bashrc
		export PATH="$HOME/.rbenv/bin:$PATH"
		eval "$(rbenv init -)"
		source ~/.bashrc
		type rbenv
		git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
		echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
		source ~/.bashrc
		rbenv install 2.6.4 #Installing required version of Ruby
		( set -x ; ruby -v )
		echo -e "${c}rbenv and defined ruby version setup Successfully."; $r
		;;

		6) 
		echo -e "${c}Setting up JRE & JDK"; $r
		sudo apt install -y default-jre
		sudo apt install -y default-jdk
		( set -x ; java -version )
		echo -e "${c}Java Installed Successfully!"; $r
		;;

		7) 
		echo -e "${c}Installing Masscan in $HOME/tools/masscan"; $r
		cd && cd tools
		git clone --depth 1 https://github.com/robertdavidgraham/masscan
		cd masscan
		make
		echo -e "${c}Masscan Installed Successfully."; $r
		;;

		8) 
		echo -e "${c}Installing Chrome"; $r
		cd
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		sudo dpkg -i google-chrome-stable_current_amd64.deb
		sudo apt --fix-broken install -y
		rm -f google-chrome-stable_current_amd64.deb
		;;

		9) 
		echo -e "${c}Installing NMAP"; $r
		sudo apt install -y nmap
		;;

		10) 
		echo -e "${c}Installing Drozer Framework"; $r
		wget https://github.com/mwrlabs/drozer/releases/download/2.4.4/drozer_2.4.4.deb
		sudo dpkg -i drozer_2.4.4.deb
		sudo apt install -y -f
		rm -f drozer_2.4.4.deb
		echo -e "${c}Drozer Framework Installed Successfully."; $r
		;;

		11) 
		echo -e "${c}Installing JADX"; $r
		cd && cd tools
		git clone --depth 1 https://github.com/skylot/jadx.git
		cd jadx
		./gradlew dist
		echo -e "${c}JADX Installed Successfully."; $r
		;;

		12) 
		echo -e "${c}Installing Ettercap"; $r
		sudo apt install -y ettercap-graphical
		;;

		13) 
		echo -e "${c}Downloading SQLMAP"; $r
		cd && cd tools
		git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
		echo -e "${c}SQLMAP Downloaded Successfully. Go to $HOME/tools/sqlmap-dev to run it."; $r
		;;

		14) 
		echo -e "${c}Installing Yara v3.10.0"; $r
		cd && cd tools
		wget https://github.com/VirusTotal/yara/archive/v3.10.0.tar.gz
		tar -zxf v3.10.0.tar.gz
		rm -f v3.10.0.tar.gz
		cd yara-3.10.0
		sudo ./bootstrap.sh
		sudo ./configure --with-crypto
		sudo make
		sudo make check
		sudo make install
		echo -e "${c}Yara Setup Successfully."; $r
		;;

		15) 
		echo -e "${c}Installing i3 Window Manager"; $r
		sudo apt install -y i3
		;;

		16) 
		echo -e "${c}Installing EyeWitness"; $r
		cd && cd tools
		git clone --depth 1 https://github.com/FortyNorthSecurity/EyeWitness.git
		cd EyeWitness/setup
		sudo ./setup.sh
		echo -e "${c}EyeWitness Installed Successfully in $HOME/tools/EyeWitness."; $r
		;;

		17) 
		echo -e "${c}Installing Skype"; $r
		wget https://go.skype.com/skypeforlinux-64.deb
		sudo apt install -y ./skypeforlinux-64.deb
		rm -f skypeforlinux-64.deb
		echo -e "${c}Skype Installed Successfully."; $r
		;;

		18) 
		echo -e "${c}Installing NodeJS"; $r
		cd
		curl -sL https://deb.nodesource.com/setup_12.x | sudo bash - #Submit the version according to your need.
		sudo apt install -y nodejs
		( set -x; nodejs -v )
		echo -e "${c}NodeJS Installed Successfully."; $r
		;;

		19) 
		echo -e "${c}Installing Sublime Text 3"; $r
		wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
		echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
		sudo apt update -y
		sudo apt install -y sublime-text
		;;

		20) 
		echo -e "${c}Installing Wireshark"; $r
		sudo apt install -y wireshark
		sudo dpkg-reconfigure wireshark-common 
		echo -e "${c}Adding user to wireshark group."; $r
		sudo usermod -aG wireshark $USER
		echo -e "${c}Wireshark Installed Successfully."; $r
		;;

		21)
		echo -e "${c}Installing Amass"; $r
		sudo snap install amass
		;;

		22)
		echo -e "${c}Installing Knockpy in $HOME/tools"; $r
		cd && cd tools
		sudo apt install -y python-dnspython
		git clone --depth 1 https://github.com/guelfoweb/knock.git
		cd knock
		sudo python setup.py install
		echo -e "${c}Knockpy Installed Successfully."; $r
		;;

		23)
 		echo -e "${c}Downloading Dirsearch in $HOME/tools"; $r
 		cd && cd tools
 		git clone --depth 1 https://github.com/maurosoria/dirsearch.git
 		echo -e "${c}Dirsearch Downloaded."; $r
 		;;

 		24)
        echo -e "${c}Installing LinkFinder in $HOME/tools"; $r
        cd && cd tools
        git clone --depth 1 https://github.com/GerbenJavado/LinkFinder.git
        cd LinkFinder
        sudo pip install argparse jsbeautifier
        sudo python setup.py install
        echo -e "${c}LinkFinder Installed Successfully."; $r
        ;;

		25)
		echo -e "${c}Installing VirtualBox"; $r
		sudo apt install -y virtualbox
		;;	    
	esac
done

# Final Upgrade and Update Command
echo -e "${c}Updating and upgrading to finish auto-setup script."; $r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
