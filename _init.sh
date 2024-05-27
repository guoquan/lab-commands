#!/bin/bash

set -e

import_common() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_common.sh
}; import_common

# load system config
import config

# load config in the current folder
if [[ -f ./env ]]; then
    source ./env
fi
