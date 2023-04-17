#!/bin/bash

echo "creating kind cluster"
kind create cluster -n conlab
echo "cluster created"

echo "loading consul-k8s image"
kind load docker-image consul-k8s-control-plane-dev:blueberry -n conlab
echo "loaded consul-k8s image"

echo "helm installing"
helm install consul ~/hashi/consul-k8s/charts/consul -n consul --create-namespace --set global.imageK8S=consul-k8s-control-plane-dev:blueberry
kubectl wait --timeout=180s --for=condition=Available=True deployments/consul-consul-connect-injector -n consul
echo "helm install finished"

echo "installing services"
kubectl apply -f ./service.yaml
echo "finished installing services"
