# autosetup
Auto setup is a simple bash script (compatible with Debian-based distributions like Ubuntu and Kali) to install and set up necessary software/tools after doing Fresh Install.

> The script is completely based on InfoSec/Bug Bounty reconnaissance tools as well as some apps I use regularly like Skype, Chrome, etc.
> You can modify it according to your need.

<!--![AutoSetup.sh](https://user-images.githubusercontent.com/20816337/130368587-124ebdb6-4d96-4716-85f0-c1866d8d8eda.png)-->
<!--![AutoSetup.sh](https://user-images.githubusercontent.com/20816337/130368430-56b15e47-2c80-4dcc-b336-f9c41a6f274d.png)-->

## Usage

```bash
git clone https://github.com/shubhampathak/autosetup.git
cd autosetup
chmod +x autosetup.sh
./autosetup.sh
```
## Operations

1. Install nala wget curl git zsh build-essential dnsutils net-tools neofetch
2. Setup Git Global Config. (It'll ask for your name and email)*
3. Show dialogbox (whiptail), where you can select the software(s) you want to install.
4. Install selected software.

**You can skip step 2 if you want.*

## List

- deno
- pnpm
- python package (python3, pip3, venv, ipython)
- visual studio code

## Other features:

### 1 - nala support

Use of `nala` for frontend interface, dependency management
and tracking of installed packages by `nala history`

### 2 - External directory for software installers:

Create a directory containing a group of shell programs
which installs the software if selected by the user.
autosetup will evaluate what programs could be installed
by reading the existing files in this directory.

```
--> autosetup.sh
--> installers
  |--> Visual studio Code.sh
  |--> Python3.sh
  |--> Firefox.sh
  |--> zsh.sh
  |--> ...
  |--> ...
  |--> ...
```

Once the user selected which programs to install,
autosetup will iterate and execute every shell until
all packages are installed.

Also, the user can add custom package installers to add programs
to the list or even create shell scripts that install multiple
packages at once.

## Contributions

We hope that you will consider contributing to autosetup. Please read this short overview [Contribution Guidelines](https://github.com/shubhampathak/autosetup/blob/master/CONTRIBUTING.md) for some information about how to get started. 

