#!/bin/bash

set -e

if [ ! -e ~/.jupyter ]; then
    mkdir -p ~/.jupyter
fi

docker run -it --rm \
	-v "$HOME":/home/"$USER" \
	-w /home/"$NB_USER" \
	-e NB_USER="$USER" \
	-e NB_UID="$UID" \
	-e NB_GROUP="hlr" \
	-e NB_GID="$(id -g hlr)" \
	-e GRANT_SUDO=yes \
	--user root \
	"hlr/lab-base:latest" \
	start-notebook.sh password
