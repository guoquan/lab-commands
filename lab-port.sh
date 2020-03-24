#!/bin/bash

set -e

ids=$(docker ps -q -a --filter name="Lab-$USER-")
for id in $ids; do
	docker inspect --format="{{.Name}} [{{.State.Status}}]: Port {{ (index (index .Config.Cmd) 2) }}" $id
    if [[ $start && $(docker inspect --format="{{.State.Status}}" $id) != "running" ]]; then
        docker start $id
    fi
done
