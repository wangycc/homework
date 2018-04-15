#!/bin/bash

function check_private(){
    sudo_private=$(sudo -A ls -l > /dev/null 2>&1)
    if [ $? -ne 0 ] && [ $UID -ne 0  ];then
        echo "Superuser privileges or sudo private are required to run this script."
    fi
}

function install::docker(){
    if [ $(command -v docker)" -ne 0  ]; then
        if [ "Linux" != "$(uname)"  ]; then
            echo "This script is meant for Linux system"
            exit
        fi
        echo Check/Installing docker
        curl -sSL https://get.docker.com |sh

        # add current user to the docker group
        sudo usermod -aG docker $USER

        # Now lets get docker compose
        echo Check/Installing docker-compose
        if [ $(command -v docker-compose) -ne 0  ]; then
          sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose 
          sudo  chmod +x  /usr/local/bin/docker-compose
        fi

        echo "docker version and docker-compose version"
        sudo docker version   
        sudo docker-compose version
}

function cleanup(){
    docker rm $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
        docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null

}

# Help 

# Help 
if [ $# -lt 1 ] || [ "$1" = "help" ]; then
   echo
   echo "$pn usage: command [arg...]"
   echo
   echo "Commands:"
   echo
   echo "train      Creates the training environment"
   echo "prod       Creates the production environment"
   echo "pack       Tag and push production images"
   echo "status     Display the status of the environment"
   echo "test       Quick test - header info only" 
   echo "bench      Run benchmarking tests" 
   echo "clean      Removes dangling images and exited containers"
   echo "images     List images"
   echo
   exit
fi 
check_private
