SHELL = bash
PROJECT_ID := $(shell gcloud config get-value project)
CLUSTER_NAME := "gke-ns-cluster"

init:
	terraform init

apply:
	terraform apply \
		-var="project_id=$(PROJECT_ID)" \
		-var="cluster_name=$(CLUSTER_NAME)" \
		-auto-approve

plan:
	terraform plan \
		-var="project_id=$(PROJECT_ID)" \
		-var="cluster_name=$(CLUSTER_NAME)"

destroy:
	terraform destroy \
		-var="project_id=$(PROJECT_ID)" \
		-var="cluster_name=$(CLUSTER_NAME)" \
		-auto-approve

# k8s commands
ctx-single-stack:
	gcloud container clusters get-credentials $(CLUSTER_NAME) \
    --zone "us-west2-a" \
		--project $(PROJECT_ID)

start: ctx-single-stack install-consul

start-local-charts: ctx-single-stack install-consul-local-charts

reset: ctx-single-stack uninstall-consul

delete-metrics-pod:
	@kubectl delete pod kube-state-metrics-0 -n gke-managed-cim

metrics-pod-status:
	@kubectl get pods -n gke-managed-cim

# consul commands
install-consul:
	./start

install-consul-local-charts:
	./start -chart-local

uninstall-consul:
	(kubectl delete -f ./consul || true) && (kubectl delete -f ./services || true) && echo "uninstalling consul, this might take a minute" && (helm uninstall consul -n consul || true) && (kubectl delete namespace consul || true)


