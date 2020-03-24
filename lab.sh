#!/bin/bash

set -e

if [[ $1 == "port" ]]; then
    shift
    lab-port $@
elif [[ $1 == "new" ]]; then
    shift
    lab-new $@
elif [[ $1 == "new-large" ]]; then
    shift
    lab-new-large $@
elif [[ $1 == "start" ]]; then
    shift
    lab-start $@
elif [[ $1 == "restart" ]]; then
    shift
    lab-restart $@
elif [[ $1 == "passwd" ]]; then
    shift
    lab-passwd $@
elif [[ $(docker ps -q -a --filter name="Lab-$USER-") ]]; then
    start=1
    lab-port $@
else
    if [[ ! -f ~/".jupyter/jupyter_notebook_config.json" ]]; then
        lab-passwd
    fi
    lab-new $@
fi
