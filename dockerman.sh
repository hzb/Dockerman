#!/usr/bin/env bash
#
# One-click installation script for Docker and Docker Compose
# Should work on sh, dash, bash, ksh, zsh
#
# Copyright (C) 2018-present, Implemented by HB <https://github.com/tourcoder>

red='\e[91m'
none='\e[0m'

# Check Root permissions
[[ $(id -u) != 0 ]] && echo -e "\n ${red}Sorry, please use root permissions\n ${none}" && exit 1

# Check supported OS
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
	if ! [ $(command -v docker) ]; then
	  # Install Docker
	  curl -sSL https://get.docker.com/ | sh
	fi

	if ! [ $(command -v docker-compose) ]; then
	  # Get latest docker compose version number
	  get_latest_release() {
	    curl --silent "https://api.github.com/repos/docker/compose/releases/latest" |
	    grep '"tag_name":' |                                          
	    sed -E 's/.*"([^"]+)".*/\1/'                                  
	  }

	  # Install Docker compose
	  curl -L https://github.com/docker/compose/releases/download/`get_latest_release`/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
	  chmod +x /usr/bin/docker-compose

	fi
else
	echo -e "\n ${red}Sorry, unsupported OS\n ${none}" && exit 1
fi

# Start Docker
service docker start

echo "*************************************************"

# Check Docker version
docker version

echo "*************************************************"

# Check Docker-compose version
docker-compose version

echo "*************************************************"

exit 1


