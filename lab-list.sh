#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

list() {
    if [[ $1 == 'long' ]]; then
        format() {
            echo "{{- .Name}} ({{.Config.Image}}) Status: [{{.State.Status}}$1] Home: {{range .Mounts -}}
                    {{- if eq .Destination \"/home/$USER\" -}}
                        [{{- .Source -}}]
                    {{- end -}}
                {{- end -}}
                ; Port: [{{- (index (index .Config.Cmd) 2) -}}]"
        }
    else
        format() {
            echo "{{- .Name}} [{{.State.Status}}$1] Port: [{{- (index (index .Config.Cmd) 2) -}}]"
        }
    fi

    local ids=$($docker ps -q -a --filter name="Lab-$USER-")
    for id in $ids; do
        if [[ $start && $($docker inspect --format="{{.State.Status}}" $id) != "running" ]]; then
            $docker start $id
            local just="(start)"
        else
            local just=""
        fi
        $docker inspect --format="$(format $just)" $id
    done
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    list $@
fi
