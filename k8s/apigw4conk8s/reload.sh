#!/bin/bash

# remove everything but keep cluster in tact
kubectl delete -f ./gw.yaml
kubectl delete -f ./httproute.yaml
kubectl delete -f ./echo-service.yaml
kubectl delete -f ./service-defaults.yaml
kubectl delete -f ./echo-service.yaml
kubectl delete secret cert-one
helm uninstall consul -n consul

# tag new version
docker tag consul-k8s-control-plane-dev:latest consul-k8s-control-plane-dev:blueberry
kind load docker-image consul-k8s-control-plane-dev:blueberry -n gwtime

# reinstall everything
helm install consul "$HOME/hashi/consul-k8s/charts/consul" -f ./consul_values.yaml -n consul --create-namespace --wait
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
kubectl apply -f httproute.yaml
kubectl get svc -n consul
