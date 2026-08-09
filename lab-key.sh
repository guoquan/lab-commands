#!/bin/bash

set -e

init() {
    local BASE=$(dirname $(realpath "$0"))
    source $BASE/_init.sh
}; init

key() {
    local port=$1
    local public_key=$2

    if [[ -z ${port:-} || -z ${public_key:-} ]]; then
        echo "usage: lab key <jupyter-port> <public-key-file>" >&2
        return 2
    fi
    local temporary_key=""
    if [[ $public_key == - ]]; then
        temporary_key=$(mktemp)
        cat > "$temporary_key"
        public_key=$temporary_key
    fi
    if [[ ! -f $public_key ]]; then
        echo "public key file not found: $public_key" >&2
        [[ -z $temporary_key ]] || rm -f "$temporary_key"
        return 2
    fi

    local name=$(user_container "$port")
    if ! $docker inspect "$name" >/dev/null 2>&1; then
        echo "container not found: $name" >&2
        [[ -z $temporary_key ]] || rm -f "$temporary_key"
        return 1
    fi

    local container_user=${container_user:-$($docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' "$name" | sed -n 's/^NB_USER=//p' | head -n1)}
    container_user=${container_user:-$USER}

    local destination="/home/$container_user/.ssh"
    local key_dir=$($docker inspect --format="{{range .Mounts}}{{if eq .Destination \"$destination\"}}{{.Source}}{{end}}{{end}}" "$name")
    if [[ -z $key_dir ]]; then
        echo "container has no dedicated SSH key mount: $name" >&2
        [[ -z $temporary_key ]] || rm -f "$temporary_key"
        return 1
    fi

    ssh-keygen -lf "$public_key" >/dev/null
    mkdir -p "$key_dir"
    touch "$key_dir/authorized_keys"
    chmod 700 "$key_dir"
    chmod 600 "$key_dir/authorized_keys"
    while IFS= read -r line; do
        [[ -z $line || $line == \#* ]] && continue
        grep -Fqx -- "$line" "$key_dir/authorized_keys" || printf '%s\n' "$line" >> "$key_dir/authorized_keys"
    done < "$public_key"
    [[ -z $temporary_key ]] || rm -f "$temporary_key"
    echo "Added public key to $name ($key_dir)."
    echo "SSH port: $((port + ssh_port_offset))"
}

if [[ $0 == "$BASH_SOURCE" ]]; then
    key "$@"
fi
