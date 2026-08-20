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
    local name=$(user_container $port)
    local group=${group:-$(id -gn)}
    local gid=$(cut -d: -f3 < <(getent group $group))
    local ghome=$(getent passwd -- ${group} | cut -d: -f6)
    local home=$(pwd)
    local container_user=${container_user:-$USER}
    local container_uid=${container_uid:-$UID}
    local container_group=${container_group:-$group}
    local container_gid=${container_gid:-$gid}
    local container_home=${container_home:-$home}
    local jupyter_dir=${jupyter_dir:-$HOME/.jupyter}
    local container_group_home=${container_group_home:-$ghome}
    local ssh_keys_dir_effective=${ssh_keys_dir:-$ssh_keys_root/$port}
    local ssh_keys_mount_opts=()
    mkdir -p "$ssh_keys_dir_effective"
    touch "$ssh_keys_dir_effective/authorized_keys"
    chmod 700 "$ssh_keys_dir_effective"
    chmod 600 "$ssh_keys_dir_effective/authorized_keys"
    ssh_keys_mount_opts=(-v "$ssh_keys_dir_effective":/home/"$container_user"/.ssh:ro)

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
        -v "$container_home":/home/"$container_user" \
        -v "$jupyter_dir":/home/"$container_user"/.jupyter \
        "${ssh_keys_mount_opts[@]}" \
        ${container_group_home:+-v "$container_group_home":/home/"$container_group"} \
        $workdir_opts \
        -e NB_USER="$container_user" \
        -e NB_UID="$container_uid" \
        -e NB_GROUP="$container_group" \
        -e NB_GID="$container_gid" \
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
    echo "Container user: $container_user (uid=$container_uid, gid=$container_gid)"
    echo "Jupyter port: $port; SSH port: $ssh_port"
    echo "For a first run, please set your password \"lab passwd\" and restart \"lab restart $port\"."
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    new $@
fi
