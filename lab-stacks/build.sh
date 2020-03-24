#!/bin/bash

set -e

images=( \
	"base" \
	"starter" \
    "jdk"
)

now=$(date +'%Y%m%d')

for image in ${images[@]}; do
	docker build --rm --force-rm -t "hlr/lab-${image}":"$now" "./${image}"
    docker tag "hlr/lab-${image}":"$now" "hlr/lab-${image}":latest
done

