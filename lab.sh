#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

import-labs list new start restart passwd discard

welcome() {
    if [[ $($docker ps -q -a --filter name=$(user_container)) ]]; then
        start=1 list
    else
        if [[ ! -f ~/.jupyter/jupyter_notebook_config.json ]]; then
            passwd
        fi
        new
    fi
}

lab() {
    local subcommand=$1
    case $subcommand in
        "" )
            welcome
            ;;
        "list" | "new" | "start" | "restart" | "passwd" | "discard" )
            shift
            $subcommand $@
            ;;
        * )
            echo usage: $0 [sub-command] [args]
            echo sub-commands: list, new, passwd, start, restart, discard
    esac
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    lab $@
fi
