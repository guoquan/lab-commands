# `Lab`

## Prepare

### Container

We need `docker`. If GPU is needed, we will need nvidia container toolkit https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/index.html
One can use other container technology, as far as they understand what is going on.
Let's say they are properly installed.

### Base Image

Now we need an base image. Jupyter docker stacks are good in most cases https://github.com/jupyter/docker-stacks
If GPU is needed, we will need to build locally with replaced root image from nvidia https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda
We usually need CUDA, CUDNN, and devel version. Find the tag and we will need it soon.

Clone `docker-stacks` into a local directory

```bash
git clone https://github.com/jupyter/docker-stacks.git
```

Go to the `docker-stacks` directory and build with alternative root image.
Customize the `OWNER` so we don't have confusion with original images. And we usually need `minimal-notebook`, which (currently) requires `docker-stacks-foundation` and `base-notebook`

```bash
cd docker-stacks
DOCKER_BUILD_ARGS="--build-arg ROOT_CONTAINER=nvcr.io/nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04" OWNER=deepq make build/docker-stacks-foundation build/base-notebook build/minimal-notebook
```

It takes a while.

Now we have `deepq/minimal-notebook` prepared. Ready to go!

## Config

In `lab` directory, edit `config.sh` for a couple of options.
We usually need to config `DEFAULT_IMAGE` to match the base image prepared above

```
DEFAULT_IMAGE=deepq/minimal-notebook
```

If one use any alternative container technology, override `docker` variable may do the job.

Additionally docker options can be added to `opts` to, for example, enable default volumn mapping or aquire additional privilege.

The options used by `lab new` can also be changed in `config.sh` while keeping the
existing defaults:

```bash
gpu_opts="--gpus all"                         # empty for CPU-only containers
network_opts="--network host"                 # or a normal Docker network
restart_opts="--restart always"
workdir_opts="-w /home"
cap_opts="--cap-add sys_admin --cap-add dac_read_search"
security_opts="--security-opt apparmor:unconfined"
ssh_enabled="yes"                            # set no to disable container SSH
ssh_port_offset=1                              # SSH port = Jupyter port + offset
```

These variables are expanded as Docker command-line options. Keep each option and
its value space-separated, and quote values that contain spaces when writing a
custom wrapper. The `opts` variable remains available for mounts and other
site-specific Docker options.

When enabled, each `lab new` container starts `sshd` on its own host-network
port. The command prints both the Jupyter and SSH ports. SSH password login is
disabled; place an authorized public key in the user's `.ssh/authorized_keys`.

Noted that we have use the host network by default so one should not need to setup port mapping.

## Install

`Makefile` should do the job.

```bash
sudo make install
```

Now, try `lab list` to see if it works.

## Usage

Use `lab` to get started, and there are sub commands `lab list`, `lab new`, `lab start`, `lab restart`, `lab passwd`, and `lab discard`.
