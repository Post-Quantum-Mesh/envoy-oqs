#!/bin/sh

# Run from CWD using "./kill.sh"

# Kill container
echo "Killing demo..."
echo
sudo docker-compose down
sudo docker volume rm $(docker volume ls -q)
#sudo docker kill $(sudo docker ps -q)
sudo docker container prune -f