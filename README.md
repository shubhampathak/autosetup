# autosetup
Auto setup is a simple bash script (compatible with Debian based distributions like Ubuntu and Kali) to install and setup necessary softwares/tools after doing Fresh Install.

> Script is completely based on InfoSec/Bug Bounty reconnaissance tools as well as some apps I use regularly like Skype, Chrome etc.
> You can Modify it according to your need.

![AutoSetup.sh](https://user-images.githubusercontent.com/20816337/58801810-399ecb80-8629-11e9-8dd7-eb6169195a9b.png)

## Usage

```bash
git clone https://github.com/shubhampathak/autosetup.git
cd autosetup
chmod +x autosetup.sh
./autosetup.sh
```
## Structure

Script will show a dialogbox (whiptail), where you can select the software(s) you want to install. 

But, before opening the dialogbox, it'll perform the following operations:

1. Install Snap, Curl, wget, DNS-Utils, ADB and Fastboot.
2. Setup Git Global Config. (It'll ask for your name and email)
3. Install all the required dependencies needed for the list of softwares.
4. Download [Daniel Miessler's SecLists](https://github.com/danielmiessler/SecLists) in $HOME/tools. (Useful duing recon and hunting)

## List

* Visual Studio Code
* Python2 and iPython
* Python3
* GoLang
* Rbenv
* JRE & JDK
* Masscan
* Chrome
* NMAP
* Drozer Framework
* Jadx
* Ettercap
* SQLMAP
* Yara
* i3 Window Manager
* EyeWitness
* Skype
* NodeJS
* Sublime Text 3
* Wireshark
* Amass
* Knockpy
* Dirsearch
* LinkFinder
* Virtual Box

## Note

Tested on Ubuntu 16.04, Ubuntu 18.04, Kali Linux Vagrant boxes, but it should work with other Debian based distributions as well.