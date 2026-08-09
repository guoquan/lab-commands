# docker command to use, default "docker"
docker=docker
# default group
group=deepq
# default docker run options
opts="-v /storage:/storage -v /storage:/home/storage"
# options for GPU access; set empty for CPU-only containers
gpu_opts="--gpus all"
# network, restart, working-directory, and privilege options
network_opts="--network host"
restart_opts="--restart always"
workdir_opts="-w /home"
cap_opts="--cap-add sys_admin --cap-add dac_read_search"
security_opts="--security-opt apparmor:unconfined"
# expose SSH on a per-container port next to the Jupyter port
ssh_enabled="yes"
ssh_port_offset=1
# optional override; by default each container gets $HOME/.lab-ssh-keys/<port>
ssh_keys_root="$HOME/.lab-ssh-keys"
ssh_keys_dir=""
# default image for new command
DEFAULT_IMAGE="quay.io/deepq/minimal-notebook:latest"
