#!/bin/bash

source 10-set-variables.sh

# enable container service
gcloud services enable container.googleapis.com

# create service account for the hub.
gcloud iam service-accounts create ${SA_GKE_HUB} --display-name ${SA_GKE_HUB} --project ${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member serviceAccount:${SA_GKE_HUB}@${PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/owner

# create service account for the single user pods.
# grant no permissions by default.
# be very careful or this may give the users root access to the cluster.
gcloud iam service-accounts create ${SA_GKE_SU} --display-name ${SA_GKE_SU} --project ${PROJECT_ID}

echo "----------------------------------------------"
echo "Creating a Workload Identity enabled cluster. "
echo "      n1-standard-2: 2vCore, 8GB              "
echo "   x: n1-standard-4: 4vCore, 15GB             "
echo "----------------------------------------------"

gcloud beta container clusters create ${CLUSTER_NAME} \
  --project ${PROJECT_ID} \
  --zone ${ZONE} \
  --release-channel regular \
  --enable-ip-alias \
  --num-nodes 3 \
  --scopes cloud-platform,userinfo-email \
  --service-account ${SA_GKE_HUB}@${PROJECT_ID}.iam.gserviceaccount.com \
  --machine-type n1-standard-4 \
  --addons ConfigConnector \
  --workload-pool=${PROJECT_ID}.svc.id.goog \
  --enable-stackdriver-kubernetes \
  --workload-metadata=GCE_METADATA  # VM authentication of inverting proxy needs GCE_METADATA; this disables WID on default pool.

gcloud container clusters get-credentials ${CLUSTER_NAME} \
  --project ${PROJECT_ID} \
  --zone ${ZONE}

gcloud beta container node-pools create user-pool \
  --machine-type n1-standard-2 \
  --num-nodes 0 \
  --enable-autoscaling \
  --min-nodes 0 \
  --max-nodes 3 \
  --zone ${ZONE} \
  --node-taints hub.jupyter.org_dedicated=user:NoSchedule \
  --node-labels hub.jupyter.org/node-purpose=user \
  --cluster ${CLUSTER_NAME} \
  --workload-metadata=GKE_METADATA  # Enable WID on the user pool.

# Set up cloud service account for kubernetes service accounts
# TODO(mayran): Look into using the Config Connector

gcloud iam service-accounts add-iam-policy-binding \
--role roles/iam.workloadIdentityUser \
--member "serviceAccount:${PROJECT_ID}.svc.id.goog[default/singleuser-runner]" \
${SA_GKE_SU}@${PROJECT_ID}.iam.gserviceaccount.com

# agent-runner and hub-runner are not ineffiective because
# default pool uses GCE_METADATA:
gcloud iam service-accounts add-iam-policy-binding \
--role roles/iam.workloadIdentityUser \
--member "serviceAccount:${PROJECT_ID}.svc.id.goog[default/agent-runner]" \
${SA_GKE_HUB}@${PROJECT_ID}.iam.gserviceaccount.com

gcloud iam service-accounts add-iam-policy-binding \
--role roles/iam.workloadIdentityUser \
--member "serviceAccount:${PROJECT_ID}.svc.id.goog[default/hub-runner]" \
${SA_GKE_HUB}@${PROJECT_ID}.iam.gserviceaccount.com
