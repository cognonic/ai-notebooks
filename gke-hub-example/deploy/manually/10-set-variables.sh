#!/bin/bash

alias k=kubectl

WORKING_DIR=$(pwd)

# set ZONE and CLUSTER_NAME as environment variables

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

echo "--------------------------------"
echo "Using project: ${PROJECT_ID}"
echo "Using cluster: ${CLUSTER_NAME}"
echo "Using zone: ${ZONE}"
echo "--------------------------------"

# Name of the service account for the GKE hub.
export SA_GKE_HUB="gke-nodes"
export SA_GKE_SU="gke-singleuser"

export FOLDER_MANIFESTS="../manifests/overlays"
export FOLDER_MANIFESTS_GKE="${FOLDER_MANIFESTS}/gke"
export FOLDER_MANIFESTS_LOCAL="${FOLDER_MANIFESTS}/local"

export DOCKER_FOLDER="../../docker"
export DOCKER_FOLDER_HUB="${DOCKER_FOLDER}/hub"
export DOCKER_FOLDER_AGENT="${DOCKER_FOLDER}/agent"
export DOCKER_FOLDER_JUPYTER="${DOCKER_FOLDER}/jupyter"

# Docker images for local deployment.
export IMAGE_HUB_NAME="gkehub-hub"
export IMAGE_HUB_TAG="latest"
export IMAGE_AGENT_NAME="gkehub-agent"
export IMAGE_AGENT_TAG="latest"

# Docker images for GKE deployment. Reuses local names
export DOCKER_HUB_GKE="gcr.io/${PROJECT_ID}/${IMAGE_HUB_NAME}:${IMAGE_HUB_TAG}"
export DOCKER_AGENT_GKE="gcr.io/${PROJECT_ID}/${IMAGE_AGENT_NAME}:${IMAGE_AGENT_TAG}"

# Docker images for Jupyter.
# Can hardcode in jupyterhub_config.py profiles
# but easier to test locally if using env variables.
# export IMAGES_JUPYTER=(jupyter-mine-basic jupyter-ain-tf-cpu)
# export IMAGES_THIRD_PARTY="gcr.io/deeplearning-platform-release/tf2-cpu"
export IMAGES_JUPYTER=(jupyter-basic jupyter-tensorflow jupyter-datascience jupyter-r jupyter-pyspark jupyter-pytorch)

export DOCKERS_JUPYTER_LOCAL=$(printf %s, "${IMAGES_JUPYTER[@]}" | sed s/.$//)
export DOCKERS_JUPYTER_GKE=$(printf "gcr.io/${PROJECT_ID}/%s", "${IMAGES_JUPYTER[@]}" | sed s/.$//)

if [ ! -z "$IMAGES_THIRD_PARTY" ]; then
  DOCKERS_JUPYTER_LOCAL=${DOCKERS_JUPYTER_LOCAL}",${IMAGES_THIRD_PARTY}"
  DOCKERS_JUPYTER_GKE=${DOCKERS_JUPYTER_GKE}",${IMAGES_THIRD_PARTY}"
fi
