#!/bin/bash

##################################################################################################
# Author: Shubham Pathak                                                                         #
# Description: Auto setup bash script to setup required programs after doing fresh install.      #
# Tested against Debian based distributions like Ubuntu and Kali Linux.                          #
##################################################################################################

# Show colours [making it fancy :)]
log_info()    { echo -e "\e[1;34m[*] $*\e[0m"; }
log_success() { echo -e "\e[1;32m[+] $*\e[0m"; }
log_warn()    { echo -e "\e[1;33m[!] $*\e[0m"; }

# --list flag: print available tools and exit
if [ "$1" = "--list" ]; then
	echo ""
	echo "AutoSetup: List of available tools"
	echo ""
	printf "  %-4s %s\n" "1"  "Visual Studio Code"
	printf "  %-4s %s\n" "2"  "SecLists"
	printf "  %-4s %s\n" "3"  "Python3, pip3, venv & iPython"
	printf "  %-4s %s\n" "4"  "Go"
	printf "  %-4s %s\n" "5"  "Ruby (via mise)"
	printf "  %-4s %s\n" "6"  "Amazon Corretto (OpenJDK 21)"
	printf "  %-4s %s\n" "7"  "Masscan"
	printf "  %-4s %s\n" "8"  "Chrome"
	printf "  %-4s %s\n" "9"  "NMAP"
	printf "  %-4s %s\n" "10" "Objection"
	printf "  %-4s %s\n" "11" "JADX"
	printf "  %-4s %s\n" "12" "httprobe"
	printf "  %-4s %s\n" "13" "SQLMAP"
	printf "  %-4s %s\n" "14" "Nuclei"
	printf "  %-4s %s\n" "15" "i3 Window Manager"
	printf "  %-4s %s\n" "16" "GoWitness"
	printf "  %-4s %s\n" "17" "Caido"
	printf "  %-4s %s\n" "18" "NodeJS (via nvm)"
	printf "  %-4s %s\n" "19" "Sublime Text"
	printf "  %-4s %s\n" "20" "Wireshark"
	printf "  %-4s %s\n" "21" "Amass"
	printf "  %-4s %s\n" "22" "Subfinder"
	printf "  %-4s %s\n" "23" "Feroxbuster"
	printf "  %-4s %s\n" "24" "LinkFinder"
	printf "  %-4s %s\n" "25" "VirtualBox"
	printf "  %-4s %s\n" "26" "httpx"
	printf "  %-4s %s\n" "27" "ffuf"
	printf "  %-4s %s\n" "28" "Katana"
	echo ""
	exit 0
fi

#Display Banner
if [[ ! -z $(command -v figlet) ]]; then
	figlet AutoSetup
	echo -e "\e[1;33m - By Shubham Pathak\e[0m"
else
	echo -e "\n\n\n\n
    _         _       ____       _
   / \  _   _| |_ ___/ ___|  ___| |_ _   _ _ __
  / _ \| | | | __/ _ \___ \ / _ \ __| | | | '_ |
 / ___ \ |_| | || (_) |__) |  __/ |_| |_| | |_) |
/_/   \_\__,_|\__\___/____/ \___|\__|\__,_| .__/
                                          |_|
                          - By Shubham Pathak\n\n\n"
fi

# 3 seconds wait time to start the setup
for i in $(seq 3 -1 1) ; do echo -ne "$i\rThe setup will start in... " ; sleep 1 ; done
echo ""

# Log all output from here onwards
LOG_FILE="$HOME/autosetup.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "AutoSetup started: $(date)"
echo ""

# Tracking arrays for post-install summary
declare -a installed_tools=()
declare -a failed_tools=()

print_summary() {
	echo ""
	echo -e "\e[1;32m================================================\e[0m"
	echo -e "\e[1;32m         Installation Summary                   \e[0m"
	echo -e "\e[1;32m================================================\e[0m"

	if [ ${#installed_tools[@]} -gt 0 ]; then
		echo -e "\e[1;32m[+] Installed:\e[0m"
		for entry in "${installed_tools[@]}"; do
			name="${entry%%|*}"
			loc="${entry##*|}"
			printf "    \e[1;32m[+]\e[0m %-28s %s\n" "$name" "$loc"
		done
	fi

	if [ ${#failed_tools[@]} -gt 0 ]; then
		echo ""
		echo -e "\e[1;31m[-] Failed:\e[0m"
		for name in "${failed_tools[@]}"; do
			printf "    \e[1;31m[-]\e[0m %s\n" "$name"
		done
	fi

	echo ""
	echo -e "\e[1;34m[*] Full log: $LOG_FILE\e[0m"
	echo -e "\e[1;32m================================================\e[0m"
}

# Show Battery Percentage on Top Bar [Debian (gnome)]
if [[ $XDG_CURRENT_DESKTOP =~ 'GNOME' ]]; then
	gsettings set org.gnome.desktop.interface show-battery-percentage true
fi

# Upgrade and Update Command
log_info "Updating and upgrading system packages..."
sudo apt update -y && sudo apt upgrade -y
sudo apt --fix-broken install -y

log_info "Installing curl and wget"
sudo apt-get install -y wget curl

log_info "Installing dnsutils and net-tools"
sudo apt install -y dnsutils net-tools

log_info "Installing ADB and Fastboot"
sudo apt install -y android-tools-adb android-tools-fastboot

log_info "Creating ~/tools directory"
cd || exit
mkdir -p tools

installGo() {
	version=$(curl -s https://go.dev/dl/ | grep -o "go[0-9.]*linux-amd64.tar.gz" | head -n1)
	log_info "Installing Go $version"
	cd || exit
	if ! wget -q "https://dl.google.com/go/$version"; then
		log_warn "Failed to download Go. Exiting."
		exit 1
	fi
	sudo tar -C /usr/local -xzf "$version"
	sudo rm -f "$version"
	log_info "Setting up GOPATH as $HOME/go"
	{
		echo "export GOPATH=$HOME/go"
		echo "export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin"
		echo "export GOBIN=$HOME/go/bin"
		echo "export GOROOT=/usr/local/go"
	} >> ~/.profile
	# shellcheck source=/dev/null
	source ~/.profile
	log_success "Go installed successfully"
}

installPython3() {
	sudo apt install -y python3
}

installCorretto() {
	log_info "Setting up Amazon Corretto (OpenJDK 21)"
	wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
	echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list
	sudo apt update; sudo apt install -y java-21-amazon-corretto-jdk
	( set -x ; java -version )
	log_success "Amazon Corretto installed successfully"
}

installSnap() {
	log_info "Installing Snap"
	sudo apt install -y snapd
	sudo systemctl start snapd
	sudo systemctl enable snapd
	sudo systemctl start apparmor
	sudo systemctl enable apparmor
	export PATH=$PATH:/snap/bin
	sudo snap refresh
}

checkInstalled() {
	log_info "Checking if $1 is installed"
	# shellcheck source=/dev/null
	source ~/.profile 2>/dev/null || true
	if ! command -v "$1" &> /dev/null; then
		log_warn "$1 not found — installing it first"
		$2 || { log_warn "$1 installation failed. Exiting."; exit 1; }
	else
		log_success "$1 already installed, skipping"
	fi
}

#Executing Install Dialog
dialogbox=(whiptail --separate-output --ok-button "Install" --title "Auto Setup Script" --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)
options=(1 "Visual Studio Code" off
	2 "SecLists" off
	3 "Python3, pip3, venv & iPython" off
	4 "Go" off
	5 "Ruby (via mise)" off
	6 "Amazon Corretto (OpenJDK 21)" off
	7 "Masscan" off
	8 "Chrome" off
	9 "NMAP" off
	10 "Objection" off
	11 "JADX" off
	12 "httprobe" off
	13 "SQLMAP" off
	14 "Nuclei" off
	15 "i3 Window Manager" off
	16 "GoWitness" off
	17 "Caido" off
	18 "NodeJS (via nvm)" off
	19 "Sublime Text" off
	20 "Wireshark" off
	21 "Amass" off
	22 "Subfinder" off
	23 "Feroxbuster" off
	24 "LinkFinder" off
	25 "VirtualBox" off
	26 "httpx" off
	27 "ffuf" off
	28 "Katana" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choices in $selected
do
	case $choices in
		1)
		if (
			set -e
			log_info "Installing Visual Studio Code"
			checkInstalled snap installSnap
			sudo snap install code --classic
			log_success "Visual Studio Code installed successfully"
		); then
			installed_tools+=("Visual Studio Code|/snap/bin/code")
		else
			failed_tools+=("Visual Studio Code")
		fi
		;;

		2)
		if (
			set -e
			log_info "Downloading SecLists into $HOME/tools"
			if [ -d ~/tools/SecLists ]; then
				git -C ~/tools/SecLists pull
			else
				git clone --depth 1 https://github.com/danielmiessler/SecLists.git ~/tools/SecLists
			fi
			log_success "SecLists ready"
		); then
			installed_tools+=("SecLists|$HOME/tools/SecLists/")
		else
			failed_tools+=("SecLists")
		fi
		;;

		3)
		if (
			set -e
			log_info "Installing Python3, pip3 and iPython"
			installPython3
			sudo apt install -y python3-pip python3-setuptools pipx
			pipx install ipython
			log_info "Installing Python dev tools and virtualenv"
			sudo apt install -y build-essential libssl-dev libffi-dev python3-dev python3-venv
			log_success "Python3 environment installed successfully"
		); then
			installed_tools+=("Python3|/usr/bin/python3")
		else
			failed_tools+=("Python3")
		fi
		;;

		4)
		if (
			set -e
			installGo
		); then
			installed_tools+=("Go|/usr/local/go/bin/go")
			# shellcheck source=/dev/null
			source ~/.profile 2>/dev/null || true
		else
			failed_tools+=("Go")
		fi
		;;

		5)
		if (
			set -e
			log_info "Installing Ruby via mise"
			sudo apt install -y extrepo
			sudo extrepo enable mise
			sudo apt update
			sudo apt install -y mise
			# shellcheck disable=SC2016
			echo 'eval "$(mise activate bash)"' >> ~/.bashrc
			# shellcheck disable=SC2016
			echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
			eval "$(mise activate bash)"
			export PATH="$HOME/.local/share/mise/shims:$PATH"
			mise settings ruby.compile=false
			mise use --global ruby@latest
			( set -x ; mise exec ruby -- ruby -v )
			log_success "mise and Ruby installed successfully"
		); then
			installed_tools+=("Ruby (mise)|$HOME/.local/share/mise/shims/ruby")
			export PATH="$HOME/.local/share/mise/shims:$PATH"
		else
			failed_tools+=("Ruby")
		fi
		;;

		6)
		if (
			set -e
			installCorretto
		); then
			installed_tools+=("Amazon Corretto|/usr/bin/java")
		else
			failed_tools+=("Amazon Corretto")
		fi
		;;

		7)
		if (
			set -e
			log_info "Installing Masscan into $HOME/tools/masscan"
			if [ -d ~/tools/masscan ]; then
				git -C ~/tools/masscan pull
			else
				git clone --depth 1 https://github.com/robertdavidgraham/masscan ~/tools/masscan
			fi
			cd ~/tools/masscan || exit
			make
			sudo make install
			log_success "Masscan installed successfully"
		); then
			installed_tools+=("Masscan|/usr/bin/masscan")
		else
			failed_tools+=("Masscan")
		fi
		;;

		8)
		if (
			set -e
			log_info "Installing Chrome"
			log_warn "Chrome download may take a while"
			cd || exit
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
			sudo dpkg -i google-chrome-stable_current_amd64.deb
			sudo apt --fix-broken install -y
			rm -f google-chrome-stable_current_amd64.deb
			log_success "Chrome installed successfully"
		); then
			installed_tools+=("Chrome|/usr/bin/google-chrome")
		else
			failed_tools+=("Chrome")
		fi
		;;

		9)
		if (
			set -e
			log_info "Installing NMAP"
			sudo apt install -y nmap
			log_success "NMAP installed successfully"
		); then
			installed_tools+=("NMAP|/usr/bin/nmap")
		else
			failed_tools+=("NMAP")
		fi
		;;

		10)
		if (
			set -e
			log_info "Installing Objection"
			checkInstalled python3 installPython3
			sudo apt install -y pipx
			pipx install objection
			log_success "Objection installed successfully"
		); then
			installed_tools+=("Objection|$HOME/.local/bin/objection")
		else
			failed_tools+=("Objection")
		fi
		;;

		11)
		if (
			set -e
			log_info "Installing JADX"
			checkInstalled java installCorretto
			if [ -d ~/tools/jadx ]; then
				git -C ~/tools/jadx pull
			else
				git clone --depth 1 https://github.com/skylot/jadx.git ~/tools/jadx
			fi
			cd ~/tools/jadx || exit
			./gradlew dist
			log_success "JADX installed successfully"
		); then
			installed_tools+=("JADX|$HOME/tools/jadx/build/jadx/bin/jadx")
		else
			failed_tools+=("JADX")
		fi
		;;

		12)
		if (
			set -e
			log_info "Installing httprobe"
			checkInstalled go installGo
			go install github.com/tomnomnom/httprobe@latest
			log_success "httprobe installed successfully"
		); then
			installed_tools+=("httprobe|$HOME/go/bin/httprobe")
		else
			failed_tools+=("httprobe")
		fi
		;;

		13)
		if (
			set -e
			log_info "Downloading SQLMAP into $HOME/tools/sqlmap-dev"
			if [ -d ~/tools/sqlmap-dev ]; then
				git -C ~/tools/sqlmap-dev pull
			else
				git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git ~/tools/sqlmap-dev
			fi
			log_success "SQLMAP ready — run it from $HOME/tools/sqlmap-dev"
		); then
			installed_tools+=("SQLMAP|$HOME/tools/sqlmap-dev/sqlmap.py")
		else
			failed_tools+=("SQLMAP")
		fi
		;;

		14)
		if (
			set -e
			log_info "Installing Nuclei"
			checkInstalled go installGo
			go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
			log_success "Nuclei installed successfully"
		); then
			installed_tools+=("Nuclei|$HOME/go/bin/nuclei")
		else
			failed_tools+=("Nuclei")
		fi
		;;

		15)
		if (
			set -e
			log_info "Installing i3 Window Manager"
			sudo apt install -y i3
			log_success "i3 installed successfully"
		); then
			installed_tools+=("i3 Window Manager|/usr/bin/i3")
		else
			failed_tools+=("i3 Window Manager")
		fi
		;;

		16)
		if (
			set -e
			log_info "Installing GoWitness"
			checkInstalled go installGo
			go install github.com/sensepost/gowitness@latest
			log_success "GoWitness installed successfully"
		); then
			installed_tools+=("GoWitness|$HOME/go/bin/gowitness")
		else
			failed_tools+=("GoWitness")
		fi
		;;

		17)
		if (
			set -e
			log_info "Installing Caido"
			sudo apt install -y jq
			CAIDO_DEB_URL=$(curl -s https://api.caido.io/releases/latest \
					| jq -r '.links[] | select(.os=="linux" and .kind=="desktop" and .arch=="x86_64" and .format=="deb") | .link')
			CAIDO_DEB=$(basename "$CAIDO_DEB_URL")
			wget -O "$CAIDO_DEB" "$CAIDO_DEB_URL"
			sudo apt install -y "./$CAIDO_DEB"
			rm -f "$CAIDO_DEB"
			log_success "Caido installed successfully"
		); then
			installed_tools+=("Caido|installed via .deb")
		else
			failed_tools+=("Caido")
		fi
		;;

		18)
		if (
			set -e
			log_info "Installing NodeJS via nvm"
			NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
			curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
			export NVM_DIR="$HOME/.nvm"
			# shellcheck source=/dev/null
			[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
			nvm install --lts
			nvm use --lts
			( set -x; node -v )
			log_success "NodeJS installed successfully via nvm"
		); then
			installed_tools+=("NodeJS|$HOME/.nvm (nvm managed)")
			export NVM_DIR="$HOME/.nvm"
			# shellcheck source=/dev/null
			[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" || true
		else
			failed_tools+=("NodeJS")
		fi
		;;

		19)
		if (
			set -e
			log_info "Installing Sublime Text"
			wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
			echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' | sudo tee /etc/apt/sources.list.d/sublime-text.sources
			sudo apt update -y
			sudo apt install -y sublime-text
			log_success "Sublime Text installed successfully"
		); then
			installed_tools+=("Sublime Text|/usr/bin/subl")
		else
			failed_tools+=("Sublime Text")
		fi
		;;

		20)
		if (
			set -e
			log_info "Installing Wireshark"
			echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
			sudo DEBIAN_FRONTEND=noninteractive apt install -y wireshark
			log_info "Adding $USER to wireshark group"
			sudo usermod -aG wireshark "$USER"
			log_success "Wireshark installed successfully"
		); then
			installed_tools+=("Wireshark|/usr/bin/wireshark")
		else
			failed_tools+=("Wireshark")
		fi
		;;

		21)
		if (
			set -e
			log_info "Installing Amass"
			checkInstalled go installGo
			CGO_ENABLED=0 go install -v github.com/owasp-amass/amass/v5/cmd/amass@main
			log_success "Amass installed successfully"
		); then
			installed_tools+=("Amass|$HOME/go/bin/amass")
		else
			failed_tools+=("Amass")
		fi
		;;

		22)
		if (
			set -e
			log_info "Installing Subfinder"
			checkInstalled go installGo
			go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
			log_success "Subfinder installed successfully"
		); then
			installed_tools+=("Subfinder|$HOME/go/bin/subfinder")
		else
			failed_tools+=("Subfinder")
		fi
		;;

		23)
		if (
			set -e
			log_info "Installing Feroxbuster"
			sudo apt install -y unzip
			curl -sLO https://github.com/epi052/feroxbuster/releases/latest/download/feroxbuster_amd64.deb.zip
			unzip -o feroxbuster_amd64.deb.zip
			deb_file=$(ls feroxbuster_*_amd64.deb 2>/dev/null | head -n1)
			sudo apt install -y "./$deb_file"
			rm -f feroxbuster_amd64.deb.zip "$deb_file"
			log_success "Feroxbuster installed successfully"
		); then
			installed_tools+=("Feroxbuster|/usr/bin/feroxbuster")
		else
			failed_tools+=("Feroxbuster")
		fi
		;;

		24)
		if (
			set -e
			log_info "Installing LinkFinder into $HOME/tools"
			if [ -d ~/tools/LinkFinder ]; then
				git -C ~/tools/LinkFinder pull
			else
				git clone --depth 1 https://github.com/GerbenJavado/LinkFinder.git ~/tools/LinkFinder
			fi
			cd ~/tools/LinkFinder || exit
			checkInstalled python3 installPython3
			sudo python3 setup.py install
			log_success "LinkFinder installed successfully"
		); then
			installed_tools+=("LinkFinder|$HOME/tools/LinkFinder/")
		else
			failed_tools+=("LinkFinder")
		fi
		;;

		25)
		if (
			set -e
			log_info "Installing VirtualBox"
			log_warn "VirtualBox installation may take a while"
			sudo apt install -y virtualbox
			log_success "VirtualBox installed successfully"
		); then
			installed_tools+=("VirtualBox|/usr/bin/VBoxManage")
		else
			failed_tools+=("VirtualBox")
		fi
		;;
		26)
		if (
			set -e
			log_info "Installing httpx"
			checkInstalled go installGo
			go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
			log_success "httpx installed successfully"
		); then
			installed_tools+=("httpx|$HOME/go/bin/httpx")
		else
			failed_tools+=("httpx")
		fi
		;;

		27)
		if (
			set -e
			log_info "Installing ffuf"
			checkInstalled go installGo
			go install github.com/ffuf/ffuf/v2@latest
			log_success "ffuf installed successfully"
		); then
			installed_tools+=("ffuf|$HOME/go/bin/ffuf")
		else
			failed_tools+=("ffuf")
		fi
		;;

		28)
		if (
			set -e
			log_info "Installing Katana"
			checkInstalled go installGo
			CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest
			log_success "Katana installed successfully"
		); then
			installed_tools+=("Katana|$HOME/go/bin/katana")
		else
			failed_tools+=("Katana")
		fi
		;;
	esac
done

# Final Upgrade and Update Command
log_info "Running final system update and cleanup"
sudo apt update -y
sudo apt --fix-broken install -y

print_summary
