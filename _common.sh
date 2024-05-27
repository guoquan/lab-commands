#!/bin/bash

import() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/${1}.sh
}

import-lab() {
    import lab-$1
}

import-labs() {
    for sc in $@; do
        import-lab $sc
    done
}

is_used() {
    [[ ! -z $(ss -tulpn | awk '{print $5}' | grep ":$1") ]]
}

new_port() {
    local lb=32768
    local port=$(( $RANDOM + $lb ))
    while $(is_used $port); do
        local port=$(( $RANDOM + $lb ));
    done
    echo $port
}

user_container() {
    echo Lab-"$USER"${1:+-"$1"}
}

_info_long="{{- .Name}} ({{.Config.Image}}) Status: [{{.State.Status}}$1] Home: {{range .Mounts -}}
        {{- if eq .Destination \"/home/$USER\" -}}
            [{{- .Source -}}]
        {{- end -}}
    {{- end -}}
    ; Port: [{{- (index (index .Config.Cmd) 2) -}}]"

_info_short="{{- .Name}} [{{.State.Status}}$1] Port: [{{- (index (index .Config.Cmd) 2) -}}]"

info(){
    local id=$1
    local format_name=$2
    case $format_name in
        'long' )
            format=$_info_long
            ;;
        'short' | * )
            format=$_info_short
            ;;
    esac
    $docker inspect --format="$format" $id
}