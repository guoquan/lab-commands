#!/bin/bash
# Copyright (c) Heterogeneous Learning and Reasoning 

set -e

if [[ "${HLR_HIDEPID}" == "1" || "${HLR_HIDEPID}" == "2" ]]; then
  # This requires the container to be run with `--cap-add sys_admin --security-opt apparmor:unconfined`
  sudo mount -t proc proc -o remount,hidepid=${HLR_HIDEPID} /proc
fi

