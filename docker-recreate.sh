#!/bin/bash

# Ensure Docker is running
sudo systemctl start docker

# Check if Docker is installed, install if not
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found, installing now..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
fi

# Check if UFW is installed, install if not
if ! command -v ufw &> /dev/null
then
    echo "UFW could not be found, installing now..."
    sudo apt update
    sudo apt install -y ufw
    sudo ufw enable
fi

# Allow SSH and port 5800 through UFW
sudo ufw allow ssh
sudo ufw allow 5800

# Stop the existing Docker container if it exists
sudo docker stop tor-browser 2>/dev/null || true

# Remove the stopped container if it exists
sudo docker rm tor-browser 2>/dev/null || true

# Pull the latest image
sudo docker pull domistyle/tor-browser

# Run a new Docker container
sudo docker run -d --name tor-browser -p 5800:5800 domistyle/tor-browser
