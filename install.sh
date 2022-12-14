#!/bin/bash

# Script to install all the dependencies and update the system
# Then it will install Docker, Docker-compose and create all
# the containers.
#
# Copyright (C) 2022 nadrelaxe <alexandre.beudard.ab@gmail.com>
#
# Please run this script on a fresh install

exiterr() { echo "Error: $1" >&2; exit 1; }

set -e
export DEBIAN_FRONTEND=noninteractive

## VARIABLES ##
INITIAL_DIR=$(pwd)
USER="kaplan"
DOMAIN_NAME="$DOMAIN_NAME"
EMAIL="$EMAIL"
TRAEFIK_FOLDER="/home/docker/traefik"
HOME_FOLDER="/home/docker/homepage"
OPT_FOLDER="/opt"
VPN_PORT=54321
VPN_PEERS="Thanos,NEX3,Echo,Deadpool"

# if not root. Request a sudo action
if [ $(whoami) != "root" ]; then
    sudo su $USER
fi

# ensure run as nonroot user
if [ $(whoami) != "$USER" ]; then
    echo "Creating user: $USER"
    sudo useradd -s /bin/bash -d /home/$USER -m -G sudo $USER 2>/dev/null || true

    # SUDO
    case `sudo grep -e "^$USER.*" /etc/sudoers >/dev/null; echo $?` in
    0)
        echo "$USER already in sudoers"
        ;;
    1)
        echo "Adding $USER to sudoers"
        sudo bash -c "echo '$USER  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
        ;;
    *)
        echo "There was a problem checking sudoers"
        ;;
    esac
fi

echo "Running as $USER"

## USER INTERACTION ##
# domain name
echo
read -p "Please write the domain name for the containers configuration : " DOMAIN_NAME
echo

# email
echo
read -p "Please write your email for lets encrypt : " EMAIL
echo

# check that figlet exists
if ! [ -x "$(command -v figlet)" ]; then
    echo "Installing figlet"
    sudo apt-get install -y figlet
fi

# check that git exists
if ! [ -x "$(command -v git)" ]; then
    echo "Installing git"
    sudo apt-get install -y git
fi

figlet "System info"

source ./scripts/get_distro.sh
figlet "Update"

# update the system
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

figlet "Docker"

# install docker
source ./scripts/install_docker.sh

# make sure docker and docker compose are installed
if ! [ -x "$(command -v docker)" ]; then
    exiterr "Docker has not installed properly"
fi

if ! [ -x "$(command -v docker-compose)" ]; then
    exiterr "Docker compose has not installed properly"
fi

figlet "Config files"

# copy the traefik templates to docker/traefik
sudo mkdir -p $TRAEFIK_FOLDER
sudo mkdir -p $HOME_FOLDER
sudo mkdir -p $OPT_FOLDER
sudo cp resources/*.toml $TRAEFIK_FOLDER
sudo cp resources/*.yml $OPT_FOLDER
sudo cp -R resources/homepage/* $HOME_FOLDER

# homepage configuration
cd $HOME_FOLDER
sudo sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" services.yaml
sudo sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" settings.yaml

# traefik configuration
cd $TRAEFIK_FOLDER
sudo touch acme.json && sudo chmod 600 acme.json
sudo sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" traefik_dynamic.toml
sudo sed -i "s/EMAIL/$EMAIL/g" traefik.toml

#docker-compose files configuration
cd $OPT_FOLDER

sudo sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" basic-config.yml
sudo sed -i "s/VPNPORT/$VPN_PORT/g" basic-config.yml
sudo sed -i "s/VPNPEERS/$VPN_PEERS/g" basic-config.yml
sudo sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" apps-config.yml

#back to the original folder
cd $INITIAL_DIR

figlet "Docker config"

# docker configuration
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo docker network create web

# Do not stop the script on first failure
# By default, the crontab is empty so it return 1
set +e

# Add crontab job to remove unused images
sudo crontab -l > tmpcron
echo "0 3 * * * /usr/bin/docker system prune -f" >> tmpcron
sudo crontab tmpcron
sudo rm tmpcron

# Re-set the stop-on-failure
set -e

# start the shit
figlet "Starting up!"

sudo docker-compose -f $OPT_FOLDER/basic-config.yml up -d

# TODO : potentially export the codes for wireguard and make sure everything is running smoothly ?

# TODO : add the useful command and all the available links 

#clear
figlet "IT WORKS"

echo "Useful information :"
echo
echo "Links :" 
echo "  - https://$DOMAIN_NAME"
echo "  - https://portainer.$DOMAIN_NAME"
echo "  - https://speedtest.$DOMAIN_NAME"
#echo "  - https://"
#echo "  - https://"
echo
echo "Please reboot the machine before checking all the applications"
echo
echo "Some unexpected behavior may occur if you don't reboot the machine"
echo
echo "Thank you for using this script ans have a great day!"
echo