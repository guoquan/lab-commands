#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

start() {
    $docker start $(user_container $1)
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    start $@
fi
