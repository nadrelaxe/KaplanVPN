# Hello world

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

## Features :

### Basic configuration : 

- Traefik for reverse proxy and https management
- Portainer for an easy web-ui container management
- Wireguard for VPN Setup
- Watchtower to always keep containers up to date
- Homer for an easy and convenient homepage
- Crontab to daily remove unused images

### Additional applications : 

NOT AVAILABLE YET! DEVELOMENT IS IN PROGRESS

- Code server, a web-based Visual Studio Code application
- RTorrent flood for torrent management

voila! 