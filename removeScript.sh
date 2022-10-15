#/bin/bash

if ! $(docker ps -q | wc -l); then
    echo "No running containers"
    exit 0
else
    sudo docker kill $(docker ps -q)
    sudo docker rm -f $(docker ps -a -q)
    sudo docker prune -f
fi

sudo rm -Rf /home/docker
sudo rm -Rf /opt/*.yml