#/bin/bash

sudo docker-compose down
sudo docker rm -f $(docker ps -a -q)
sudo docker volume rm $(docker volume ls -q)
sudo docker prune -f

sudo rm -Rf /home/docker
sudo rm -Rf /opt/*.yml