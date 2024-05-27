#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

passwd() {
    if [ ! -e ~/.jupyter ]; then
        mkdir -p ~/.jupyter
    fi

    local group=${group:-$(id -gn)}
    local gid=$(cut -d: -f3 < <(getent group $group))

    $docker run -it --rm \
        -v "$HOME":/home/"$USER" \
        -w /home/"$NB_USER" \
        -e NB_USER="$USER" \
        -e NB_UID="$UID" \
        -e NB_GROUP="$group" \
        -e NB_GID="$gid" \
        -e GRANT_SUDO=yes \
        --user root \
        $DEFAULT_IMAGE \
        start-notebook.sh password
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    passwd $@
fi

