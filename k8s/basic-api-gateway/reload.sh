#!/bin/bash

kubectl delete -f ./service.yaml
kubectl apply -f ./service.yaml
