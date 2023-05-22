#!/bin/bash

set -e

if [ -z "$(kind get clusters | rg "gwtime")" ]; then
    kind create cluster --config cluster.yaml
fi
# The following line assumes that you have compiled the image locally using `make docker/dev` from the api-gateway repo
kind load docker-image consul-k8s-control-plane-dev:blueberry -n gwtime
kind load docker-image consul:local -n gwtime
echo "helm installing"
helm install consul "$HOME/hashi/consul-k8s/charts/consul" -f ./consul_values.yaml -n consul --create-namespace --wait
echo "helm is done"
kubectl wait --timeout=180s --for=condition=Available=True deployments/consul-consul-connect-injector -n consul
kubectl apply -f service-default.yaml
kubectl apply -f echo-service.yaml
kubectl apply -f gw.yaml
while ! kubectl get deployments api-gateway; do sleep 1; done
kubectl wait --timeout=180s --for=condition=Available=True deployments/api-gateway
kubectl apply -f httproute.yaml
kubectl get svc -n consul
