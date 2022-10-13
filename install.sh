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
TRAEFIK_DEFAULT_PASSWORD="$TRAEFIK_DEFAULT_PASSWORD"
DOMAIN_NAME="$DOMAIN_NAME"
TRAEFIK_FOLDER="/home/docker/traefik"
OPT_FOLDER="/opt"

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
# traefik password
while [ -z "${TRAEFIK_DEFAULT_PASSWORD}" ]; do
    echo
    echo "The default admin password may only container alphanumeric characters and _"
    read -p "Please write the default admin password : " -s TRAEFIK_DEFAULT_PASSWORD
    echo

    if [[ ${TRAEFIK_DEFAULT_PASSWORD} =~ ^[A-Za-z0-9_]+$ ]]; then
        echo "Password accepted"
    else
        unset TRAEFIK_DEFAULT_PASSWORD
        echo "Try again"
    fi
done

# domain name
echo
read -p "Please write the domain name for the containers configuration : " DOMAIN_NAME
echo

# email
echo
read -p "Please write your email for lets encrypt : " DOMAIN_NAME
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

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER

figlet "Admin password"

# apache tools + traefik admin password
sudo apt-get install -y apache2-utils
ENC_TRAEFIK_PASSWORD=$(htpasswd -nb admin $TRAEFIK_DEFAULT_PASSWORD)

figlet "Domain name"

figlet "Config files"

# copy the traefik templates to docker/traefik
sudo mkdir -p $TRAEFIK_FOLDER
sudo mkdir -p $OPT_FOLDER

sudo cp *.toml $TRAEFIK_FOLDER
sudo cp *.yml $OPT_FOLDER

cd $TRAEFIK_FOLDER
sudo touch acme.json && sudo chmod 600 acme.json

sed -i "s/TRAEFIKPASSWORD/$ENC_TRAEFIK_PASSWORD/g" traefik_dynamic.toml
sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" traefik_dynamic.toml
sed -i "s/EMAIL/$DOMAIN_NAME/g" traefik.toml

cd $OPT_FOLDER

sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" basic-config.yml
sed -i "s/MACHINEDOMAIN/$DOMAIN_NAME/g" apps-config.yml
sed -i "s/SECRETPASSWORD/$TRAEFIK_DEFAULT_PASSWORD/g" apps-config.yml

#back to the original folder
cd $INITIAL_DIR

figlet "Docker config"

# docker configuration
sudo docker network create web

figlet "Starting up!"
#start the shit and make profit

# potentially export the codes for wireguard and make sure everything is running smoothly ?

#TODO : Add a reminder to reboot the machine after the installation