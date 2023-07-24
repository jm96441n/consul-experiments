#!/bin/bash

set -e

export CONSUL_K8S_CHARTS_LOCATION="$HOME/hashi/consul-k8s/charts/consul"

# remove everything but keep cluster in tact
kubectl delete -f ./consul/gw.yaml
kubectl delete -f ./consul/httproute.yaml
kubectl delete -f ./services
kubectl delete -f ./consul/service-defaults.yaml
helm uninstall consul -n consul

# tag new version
docker tag consul-k8s-control-plane-dev:latest consul-k8s-control-plane-dev:local
kind load docker-image consul-k8s-control-plane-dev:local -n gwtime

# reinstall everything
echo "helm installing"
helm install consul "$CONSUL_K8S_CHARTS_LOCATION" -f ./consul/consul_values.yaml -n consul --create-namespace --wait
echo "helm is done"
kubectl wait --timeout=180s --for=condition=Available=True deployments/consul-consul-connect-injector -n consul
kubectl apply -f ./consul/service-defaults.yaml
kubectl apply -f ./services
kubectl apply -f gw.yaml
while ! kubectl get deployments gateway; do sleep 1; done
kubectl wait --timeout=180s --for=condition=Available=True deployments/gateway || true
kubectl apply -f ./consul/jwt-provider.yaml
kubectl apply -f ./consul/httproute.yaml
kubectl apply -f ./consul/jwt-intention.yaml
kubectl get svc -n consul
