#!/bin/bash

echo "creating kind cluster"
kind create cluster -n conlab --config cluster.yaml
echo "cluster created"

echo "loading consul-k8s image"
kind load docker-image consul-k8s-control-plane-dev:blueberry -n conlab
echo "loaded consul-k8s image"

echo "helm installing"
helm install consul ~/hashi/consul-k8s/charts/consul -n consul --create-namespace --values ./consul_values.yaml
while ! kubectl get deployments consul-connect-injector -n consul; do sleep 1; done
kubectl wait --timeout=180s --for=condition=Available=True deployments/consul-consul-connect-injector -n consul
echo "helm install finished"

kubectl apply -f proxy-defaults.yaml

echo "installing services"
kubectl apply -f ./service.yaml
echo "finished installing services"
