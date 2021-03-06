#!/bin/bash

PROJECT_ID=$(gcloud config list --format 'value(core.project)')

echo "--------------------------------"
echo "Using project ${PROJECT_ID}"
echo "--------------------------------"

echo "--------------------------------"
echo "Installs kubectl"
echo "--------------------------------"
case $(uname -s) in
  Linux*)
    echo "Installing for Linux."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
  ;;
  Darwin*)
    echo "Installing for MacOs."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
  ;;
esac
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "--------------------------------"
echo "Installs minikube tools."
echo "--------------------------------"
case $(uname -s) in
  Linux*)
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  ;;
  Darwin*)
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
  ;;
esac
chmod +x minikube

sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

echo "--------------------------------"
echo "Installs kustomize."
echo "--------------------------------"
curl -s "https://raw.githubusercontent.com/\
kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
chmod +x ./kustomize
sudo mv ./kustomize /usr/local/bin/kustomize
