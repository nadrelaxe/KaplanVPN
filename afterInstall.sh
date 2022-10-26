#!/bin/bash

# Script to enable the portainer api. After running install.sh
# configure Portainer with admin user and create another user
# get the API key and enter when prompted.
#
# Copyright (C) 2022 nadrelaxe
#
# Please run this script once the install is finished and portainer is setup

API_KEY="$API_KEY"
HOME_FOLDER="/home/docker/homepage"

#  Get the API KEY 
echo
read -p "Enter the portainer API KEY : " API_KEY
echo

cd $HOME_FOLDER
sudo sed -i "s/REPLACEKEY/$API_KEY/g" services.yaml

docker restart portainer 

echo "The setup is ready. Go to homepage to see the full setup"
echo
