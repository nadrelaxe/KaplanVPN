#/bin/bash

sudo docker kill $(docker ps -q)
sudo docker rm -f $(docker ps -a -q)
sudo docker prune -f

sudo rm -Rf /home/docker
sudo rm -Rf /opt/*.yml