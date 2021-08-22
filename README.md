# autosetup
Auto setup is a simple bash script (compatible with Debian-based distributions like Ubuntu and Kali) to install and set up necessary software/tools after doing Fresh Install.

> The script is completely based on InfoSec/Bug Bounty reconnaissance tools as well as some apps I use regularly like Skype, Chrome, etc.
> You can modify it according to your need.

![AutoSetup.sh](https://user-images.githubusercontent.com/20816337/130368587-124ebdb6-4d96-4716-85f0-c1866d8d8eda.png)
![AutoSetup.sh](https://user-images.githubusercontent.com/20816337/130368430-56b15e47-2c80-4dcc-b336-f9c41a6f274d.png)

## Usage

```bash
git clone https://github.com/shubhampathak/autosetup.git
cd autosetup
chmod +x autosetup.sh
./autosetup.sh
```
## Structure

The script will show a dialogbox (whiptail), where you can select the software(s) you want to install. 

But, before opening the dialogbox, it'll perform the following operations:

1. Install snap, curl, wget, dns-utils, adb and fastboot.
2. Setup Git Global Config. (It'll ask for your name and email)*
3. Install all the required dependencies needed for the list of tools.

**You can skip 2 if you want.*

## List

* Visual Studio Code
* Daniel Miessler's SecLists
* Python3, virtualenv, pip3
* Go
* Rbenv
* Amazon Corretto (OpenJDK)
* Masscan
* Chrome
* NMAP
* Drozer Framework
* Jadx
* httprobe
* SQLMAP
* Nuclei
* i3 Window Manager
* Aquatone
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

Tested on Ubuntu 16.04, 18.04, 20.04, Kali Linux Vagrant boxes, but it should work with other Debian-based distributions as well.

## Contributions

We hope that you will consider contributing to autosetup. Please read this short overview [Contribution Guidelines](https://github.com/shubhampathak/autosetup/blob/master/CONTRIBUTING.md) for some information about how to get started. 

