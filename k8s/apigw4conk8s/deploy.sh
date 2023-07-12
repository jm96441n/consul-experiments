#!/bin/bash

set -e

if [ -z "$(kind get clusters | rg "gwtime")" ]; then
    kind create cluster --config cluster.yaml
fi
docker tag consul-k8s-control-plane-dev:latest consul-k8s-control-plane-dev:blueberry

# The following line assumes that you have compiled the image locally using `make docker/dev` from the consul-k8s repo
kind load docker-image consul-k8s-control-plane-dev:blueberry -n gwtime
kind load docker-image consul:local -n gwtime
echo "helm installing"
helm install consul "$HOME/hashi/consul-k8s/charts/consul" -f ./consul_values.yaml -n consul --create-namespace --wait
echo "helm is done"
kubectl wait --timeout=180s --for=condition=Available=True deployments/consul-consul-connect-injector -n consul
kubectl create secret tls cert-one --cert=./cert-good.crt --key=./priv-good.key
kubectl apply -f service-defaults.yaml
kubectl apply -f echo-service.yaml
kubectl apply -f gw.yaml
while ! kubectl get deployments gateway; do sleep 1; done
kubectl wait --timeout=180s --for=condition=Available=True deployments/gateway || true
kubectl create secret tls cert-one --cert=./cert-good.crt --key=./priv-good.key
kubectl apply -f httproute.yaml
kubectl get svc -n consul
