#!/bin/bash

set -e

is_used()
{
	[[ ! -z $(ss -tulpn | awk '{print $5}' | grep ":$1") ]]
}

image=${1:-"hlr/lab-starter:latest"}

port=$(( $RANDOM + 32768 ))
while $(is_used $port); do
	port=$(( $RANDOM + 32768 ));
done

name="Lab-$USER-$port"

id=$(docker run -d --name "$name" \
	--runtime nvidia \
	-v /home/hlr/shared:/home/hlr/shared \
	-v /home/hlr/scripts:/home/hlr/scripts \
	-v "$HOME":/home/"$USER" \
	-w /home/"$NB_USER" \
	-e NB_USER="$USER" \
	-e NB_UID="$UID" \
	-e NB_GROUP="hlr" \
	-e NB_GID="$(id -g hlr)" \
	-e JUPYTER_ENABLE_LAB=yes \
	-e RESTARTABLE=yes \
	-e GRANT_SUDO=yes \
    -e HLR_HIDEPID=1 \
	--user root \
	--restart always \
    --network host \
	--cap-add sys_admin \
	--cap-add dac_read_search \
	--security-opt apparmor:unconfined \
	$image \
	start-notebook.sh --port $port)

echo "Port: $port"
echo "For a first run, please please set your password with \"lab passwd\" and then restart "