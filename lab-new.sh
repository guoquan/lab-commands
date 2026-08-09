#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

new() {
    local image=${image:-${DEFAULT_IMAGE}}
    local opts=${opts}
    local port=${port:-$(new_port)}
    local ssh_port=$((port + ssh_port_offset))
    local ssh_keys_mount_opts=()
    if [[ -n ${ssh_keys_dir:-} ]]; then
        ssh_keys_mount_opts=(-v "$ssh_keys_dir":/home/"$USER"/.ssh:ro)
    fi
    local name=$(user_container $port)
    local group=${group:-$(id -gn)}
    local gid=$(cut -d: -f3 < <(getent group $group))
    local ghome=$(getent passwd -- ${group} | cut -d: -f6)
    local home=$(pwd)

    while [ "$home" != "$HOME" ]; do
        echo
        echo "NOTICE: You are away from home ($HOME)."
        echo "Lab will mount current working directory to your user home for this container."
        echo "$home -> /home/$USER"
        echo
        read -p "Do you want to continue? [Yes/No] " yn
        case $yn in
            [Yy]es )
                break
                ;;
            [Nn]* )
                echo
                echo "If you want to mount your user home for a container, start the command in user home ($HOME)"
                echo "Example:"
                echo "$ cd ~"
                echo "$ lab"
                exit
                ;;
            * )
                echo "Please answer Yes or No."
                ;;
        esac
    done

    local id=$($docker run -d --name "$name" \
        $gpu_opts \
        -v "$home":/home/"$USER" \
        -v "$HOME"/.jupyter:/home/"$USER"/.jupyter \
        "${ssh_keys_mount_opts[@]}" \
        ${ghome:+-v "$ghome":/home/"$group"} \
        $workdir_opts \
        -e NB_USER="$USER" \
        -e NB_UID="$UID" \
        -e NB_GROUP="$group" \
        -e NB_GID="$gid" \
        -e JUPYTER_ENABLE_LAB=yes \
        -e RESTARTABLE=yes \
        -e GRANT_SUDO=yes \
        -e LAB_SSH_ENABLED="$ssh_enabled" \
        -e LAB_SSH_PORT="$ssh_port" \
        --user root \
        $restart_opts \
        $network_opts \
        $cap_opts \
        $security_opts \
        $opts \
        $image \
        start-notebook.sh --port $port)

    echo "Container ID: $id"
    info $id long
    echo "Jupyter port: $port; SSH port: $ssh_port"
    echo "For a first run, please set your password \"lab passwd\" and restart \"lab restart $port\"."
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    new $@
fi
