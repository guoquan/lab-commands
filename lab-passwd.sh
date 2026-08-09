#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

passwd() {
    local group=${group:-$(id -gn)}
    local gid=$(cut -d: -f3 < <(getent group $group))
    local container_user=${container_user:-$USER}
    local container_uid=${container_uid:-$UID}
    local container_group=${container_group:-$group}
    local container_gid=${container_gid:-$gid}
    local container_home=${container_home:-$HOME}
    local jupyter_dir=${jupyter_dir:-$HOME/.jupyter}
    mkdir -p "$jupyter_dir"

    $docker run -it --rm \
        -v "$container_home":/home/"$container_user" \
        -v "$jupyter_dir":/home/"$container_user"/.jupyter \
        -w /home/"$container_user" \
        -e NB_USER="$container_user" \
        -e NB_UID="$container_uid" \
        -e NB_GROUP="$container_group" \
        -e NB_GID="$container_gid" \
        -e GRANT_SUDO=yes \
        --user root \
        $DEFAULT_IMAGE \
        start-notebook.sh password
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    passwd $@
fi
