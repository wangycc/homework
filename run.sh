#!/bin/bash

function check_private(){
    sudo_private=$(sudo -A ls -l > /dev/null 2>&1)
    if [ $? -ne 0 ] && [ $UID -ne 0  ];then
        echo "Superuser privileges or sudo private are required to run this script."
    fi
}

function install::docker(){
    ret=$(command -v docker)
    if [ "$?" -ne 0  ];then
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
    fi
    ret=$(command -v docker-compose)
    if [ "$?" -ne 0  ]; then
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

case $1 in
install)
	install::docker
	;;
cleanup)
	cleanup
	;;
*)
	echo "USAGE $0 [install|cleanup]" 
	;;
esac
