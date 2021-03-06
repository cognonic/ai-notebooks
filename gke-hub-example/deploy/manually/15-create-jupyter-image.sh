#!/bin/bash

# Usage: bash 15-create-jupyter-image.sh TARGET DOCKER_FOLDER IMAGE_JUPYTER_TAG
# Example: bash 15-create-jupyter-image.sh local jupyter-mine-basic jupyter-mine-basic
# Example: bash 15-create-jupyter-image.sh gke jupyter-mine-basic gcr.io/mam-nooage/jupyter-mine-basic

source 10-set-variables.sh

TARGET=$1
DOCKER_FOLDER=${DOCKER_FOLDER_JUPYTER}/$2
IMAGE_JUPYTER_TAG=$3

if [ "$TARGET" == "gke" ]; then

  gcloud builds submit -t ${IMAGE_JUPYTER_TAG} --timeout="30m" ${DOCKER_FOLDER}

elif [ "$TARGET" == "local" ]; then

  docker build -t ${IMAGE_JUPYTER_TAG} ${DOCKER_FOLDER}

else

  echo "echo Target ${TARGET} not supported."

fi
