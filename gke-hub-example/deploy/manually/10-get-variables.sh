#!/bin/bash

echo ""
echo "General settings:"
echo "  - Working directory: $(pwd)       "
echo "  - Using project: ${PROJECT_ID}    "
echo "  - Using cluster: ${CLUSTER_NAME}  "
echo "  - Using zone: ${ZONE}             "

echo ""
echo "GKE settings:"
echo "  - GKE nodes: ${SA_GKE_HUB}        "
echo "  - GKE singleuser: ${SA_GKE_SU}    "

echo ""
echo "Manifest folders:"
echo "  - Manifests: ${FOLDER_MANIFESTS}"
echo "  - Manifests GKE: ${FOLDER_MANIFESTS_GKE}"
echo "  - Manifests local: ${FOLDER_MANIFESTS_LOCAL}"

# Docker folders.
echo ""
echo "Docker folders:"
echo "  - Docker: ${DOCKER_FOLDER}"
echo "  - Docker hub: ${DOCKER_FOLDER_HUB}"
echo "  - Docker agent: ${DOCKER_FOLDER_AGENT}"
echo "  - Docker jupyter: ${DOCKER_FOLDER_JUPYTER}"

# Docker images for local deployment.
echo ""
echo "Docker images for local deployment:"
echo "  - imageHubName: ${IMAGE_HUB_NAME}"
echo "  - imageHubTag: ${IMAGE_HUB_TAG}"
echo "  - imageAgentName: ${IMAGE_AGENT_NAME}"
echo "  - imageAgentTag: ${IMAGE_AGENT_TAG}"

# Docker images for GKE deployment. Reuses local names
echo ""
echo "Docker images for GKE deployment:"
echo "  - DockerHubGKE: ${DOCKER_HUB_GKE}"
echo "  - DockerAgentGKE: ${DOCKER_AGENT_GKE}"

# Docker images for Jupyter.
echo ""
echo "Docker Jupyter images:"
echo "  - images[${IMAGES_JUPYTER}]"

if [ ! -z "$IMAGES_THIRD_PARTY" ]; then
  DOCKERS_JUPYTER_LOCAL=${DOCKERS_JUPYTER_LOCAL}",${IMAGES_THIRD_PARTY}"
  DOCKERS_JUPYTER_GKE=${DOCKERS_JUPYTER_GKE}",${IMAGES_THIRD_PARTY}"
fi

echo ""
echo "Docker Jupyter:"
echo "  - DockersJupyterLocal: ${DOCKERS_JUPYTER_LOCAL}"
echo "  - DockersJupyterGKE: ${DOCKERS_JUPYTER_GKE}"
echo ""
