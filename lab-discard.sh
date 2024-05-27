#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

discard() {
    local port=${1:-$port}
    local name=$(user_container $port)

    if [[ _=$($docker inspect $name >/dev/null 2>&1) && $? == 0 ]]; then
        set -e
        while true; do
            echo
            echo "NOTICE: You are going to stop container $name and remove it permanently."
            echo
            read -p "Do you want to continue? [Yes/No] " yn
            case $yn in
                [Yy]es )
                    break
                    ;;
                [Nn]* )
                    exit
                    ;;
                * )
                    echo "Please answer Yes or No."
                    ;;
            esac
        done
        $docker stop $name
        $docker rm $name
        echo "$name removed."
    else
        echo "Specific container with port [$1] is not found."
    fi

}
