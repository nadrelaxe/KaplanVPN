# KaplanVPN

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/nadrelaxe/KaplanVPN)
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/nadrelaxe/KaplanVPN/blob/master/LICENSE)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![GitHub latest commit](https://badgen.net/github/last-commit/Naereen/Strapdown.js)](https://github.com/nadrelaxe/KaplanVPN/)

[![Visual Studio Code](https://img.shields.io/badge/--007ACC?logo=visual%20studio%20code&logoColor=ffffff)](https://code.visualstudio.com/)
[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://https://docker.com/)


<p align="center">
   <img src="resources/homer/myicons/logo-color.png" alt="Kaplan logo" width="500"/>
</p>

KaplanVPN is a shell script and resources to deploy a plug-and-play privacy environment. It is easy to maintain with Portainer that allows to see the docker containers through web-ui.

It will also deploy Wireguard VPN ~~and IKEv2 + L2TP/IPSeC VPN~~ for privacy and easily change the ip.

## Tables of contents

- [KaplanVPN](#kaplanvpn)
  - [Tables of contents](#tables-of-contents)
  - [Features](#features)
    - [Basic configuration](#basic-configuration)
    - [Additional applications](#additional-applications)
  - [Getting started](#getting-started)

## Features

### Basic configuration

- [Traefik](https://github.com/traefik/traefik) for reverse proxy and https management
- [Portainer](https://www.portainer.io/) for an easy web-ui container management
- [Wireguard](https://www.wireguard.com/) for VPN Setup
- [Watchtower](https://github.com/containrrr/watchtower) to always keep containers up to date
- [Homer](https://github.com/bastienwirtz/homer) for an easy and convenient homepage
- [Crontab](https://man7.org/linux/man-pages/man5/crontab.5.html) to daily remove unused images

### Additional applications

**NOT AVAILABLE YET! DEVELOMENT IS IN PROGRESS**

- Code server, a web-based Visual Studio Code application
- RTorrent flood for torrent management
  
## Getting started

To Start Using the script, first install git on your system : 

```shell
apt-get install -y git
```

then clone this repository in a folder

```shell
cd /tmp && \
git clone https://github.com/nadrelaxe/KaplanVPN.git && \
cd KaplanVPN/ && \
chmod +x install.sh && ./install.sh
```