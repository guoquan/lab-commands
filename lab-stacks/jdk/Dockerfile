ARG BASE_CONTAINER=hlr/lab-starter
FROM $BASE_CONTAINER

LABEL maintainer="Heterogeneous Learning and Reasoning <hlr@egr.msu.edu>"

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \
    default-jdk \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
