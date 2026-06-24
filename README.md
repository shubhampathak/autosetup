# autosetup

<p align="center">
  <a href="https://github.com/shubhampathak/autosetup/stargazers"><img src="https://img.shields.io/github/stars/shubhampathak/autosetup?style=for-the-badge&color=f5c518&labelColor=1a1a2e" alt="Stars"></a>
  <a href="https://github.com/shubhampathak/autosetup/network/members"><img src="https://img.shields.io/github/forks/shubhampathak/autosetup?style=for-the-badge&color=58a6ff&labelColor=1a1a2e" alt="Forks"></a>
  <a href="https://github.com/shubhampathak/autosetup/issues"><img src="https://img.shields.io/github/issues/shubhampathak/autosetup?style=for-the-badge&color=f85149&labelColor=1a1a2e" alt="Issues"></a>
  <a href="https://github.com/shubhampathak/autosetup/blob/master/LICENSE"><img src="https://img.shields.io/github/license/shubhampathak/autosetup?style=for-the-badge&color=3fb950&labelColor=1a1a2e" alt="License"></a>
  <a href="https://github.com/shubhampathak/autosetup/commits/master"><img src="https://img.shields.io/github/last-commit/shubhampathak/autosetup?style=for-the-badge&color=a371f7&labelColor=1a1a2e" alt="Last Commit"></a>
  <img src="https://img.shields.io/badge/platform-Ubuntu%20%7C%20Debian%20%7C%20Kali-e95420?style=for-the-badge&labelColor=1a1a2e" alt="Platform">
  <img src="https://img.shields.io/badge/shell-bash-4eaa25?style=for-the-badge&logo=gnubash&logoColor=white&labelColor=1a1a2e" alt="Shell">
</p>

A bash script to quickly set up a fresh Debian-based Linux system (Ubuntu, Kali) with InfoSec, Bug Bounty, and everyday tools — without having to install everything manually.

> You can modify the script to add or remove tools based on your needs.

![AutoSetup.sh](https://user-images.githubusercontent.com/20816337/130368587-124ebdb6-4d96-4716-85f0-c1866d8d8eda.png)
![AutoSetup.sh](https://user-images.githubusercontent.com/20816337/130368430-56b15e47-2c80-4dcc-b336-f9c41a6f274d.png)

## Usage

```bash
git clone https://github.com/shubhampathak/autosetup.git
cd autosetup
chmod +x autosetup.sh
./autosetup.sh
```

To list all available tools without running the script:

```bash
./autosetup.sh --list
```

## How it works

When you run the script, it first does the following automatically:

1. Updates and upgrades all system packages.
2. Installs base dependencies: `curl`, `wget`, `dnsutils`, `net-tools`, ADB, and Fastboot.
3. Creates a `~/tools/` directory for cloned repositories and source-built tools.

After that, a checklist dialog appears where you can select the tools you want to install. Use `Space` to select/deselect and `Enter` to confirm.

At the end, the script prints a summary table showing which tools were installed successfully, which failed, and where each tool is located.

All output is also written to `~/autosetup.log` so you can review what happened.

## Tools List

### Recon

| Tool | Description |
| ------ | ----------- |
| SecLists | Collection of wordlists for security testing |
| httprobe | Probe a list of domains for working HTTP/HTTPS servers |
| httpx | Fast multi-purpose HTTP toolkit for probing and analysis |
| Nuclei | Fast vulnerability scanner using community templates |
| GoWitness | Web screenshot utility using Chrome headless |
| Amass | In-depth DNS enumeration and attack surface mapping |
| Subfinder | Passive subdomain discovery tool |
| Katana | Fast web crawler and spider for attack surface discovery |
| LinkFinder | Discover endpoints and their parameters in JavaScript files |

### Web Pentesting

| Tool | Description |
| ------ | ----------- |
| Caido | Lightweight web security auditing proxy |
| SQLMAP | Automated SQL injection detection and exploitation |
| Feroxbuster | Fast, recursive content discovery tool |
| ffuf | Fast web fuzzer for directories, parameters, and more |

### Mobile Pentesting

| Tool | Description |
| ------ | ----------- |
| Objection | Runtime mobile exploration toolkit powered by Frida |
| JADX | Dex to Java decompiler with GUI |

### Languages & Runtimes

| Tool | Description |
| ------ | ----------- |
| Python3, pip3, pipx, venv & iPython | Python3 with pip, pipx, virtual environments, and iPython |
| Go | Go programming language |
| Ruby (via mise) | Ruby installed via mise (precompiled, no build required) |
| Amazon Corretto (OpenJDK 21) | Amazon's distribution of OpenJDK |
| NodeJS (via nvm) | Node.js LTS installed via nvm |

### Network

| Tool | Description |
| ------ | ----------- |
| Masscan | Fast TCP port scanner |
| NMAP | Network exploration and security auditing |
| Wireshark | Network protocol analyzer |

### Editors & Desktop

| Tool | Description |
| ------ | ----------- |
| Visual Studio Code | Code editor (via snap) |
| Sublime Text | Text editor |
| i3 Window Manager | Tiling window manager |

### Utilities

| Tool | Description |
| ------ | ----------- |
| Chrome | Google Chrome browser |
| VirtualBox | Desktop virtualization |

## Note

Tested on Ubuntu 22.04, 24.04 and Kali Linux. However, it should work on any Debian-based distribution.

## Contributions

Contributions are welcome! Please read the [Contribution Guidelines](https://github.com/shubhampathak/autosetup/blob/master/CONTRIBUTING.md) before submitting a pull request.
