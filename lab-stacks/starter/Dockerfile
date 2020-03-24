ARG BASE_CONTAINER=hlr/lab-base
FROM $BASE_CONTAINER

LABEL maintainer="Heterogeneous Learning and Reasoning <hlr@egr.msu.edu>"

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \
    vim \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN conda install --quiet --yes -c pytorch \
    pytorch=1.4 \
    cudatoolkit=10.1 && \
    conda install --quiet --yes -c gurobi \
    gurobi && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Add local files as late as possible to avoid cache busting
COPY hlr-start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
