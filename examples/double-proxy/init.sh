#!/bin/sh

echo "Initializing..."
echo
#sudo docker-compose pull
sudo docker-compose build
sudo docker-compose up -d
sudo docker-compose ps