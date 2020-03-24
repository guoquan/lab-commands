ARG ROOT_CONTAINER=jupyter/minimal-notebook
ARG BASE_CONTAINER=$ROOT_CONTAINER
FROM $BASE_CONTAINER

LABEL maintainer="Heterogeneous Learning and Reasoning <hlr@egr.msu.edu>"

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
