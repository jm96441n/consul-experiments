# GKE-NS-Testing

Tasks are run with make:
## Run the Example

### Prerequisites
- GCP account in doormat with the kubernetes-engine apis in the UI [link](https://console.cloud.google.com/flows/enableapi?apiid=artifactregistry.googleapis.com,container.googleapis.com)
- Terraform is installed
- gcloud cli utility is installed
- A consul enterprise license in an env variable named `CONSUL_LICENSE`
- The location of your local consul-k8s charts in an environment variable named `CONSUL_K8S_CHARTS_LOCATION`

### Setup your env
Run the following to ensure the terraform provider is set up correctly:
```bash
gcloud auth application-default login
```
Run the following to ensure the gcloud cli is set up correctly:
```bash
gcloud auth login
```

Run the following to init the terraform provider:
```bash
make init
```

### Set up the k8s clusters
Run:
```bash
make apply
```
This will create the necessary resources in GCP. It creates a single GKE cluster.

### Install consul with bug
Run:
```bash
make start
```
This will install consul via the `consul_values.yaml` file and using the helm charts from the remote repository.

### Check the metrics pod status
GKE will install metrics pods in a GKE owned namespace. This pod typically runs 2 containers
```bash
make metrics-pod-status
```

You should see something like 
```
NAME                   READY   STATUS    RESTARTS   AGE
kube-state-metrics-0   2/2     Running   0          2m43s
```

### Restart the metrics pod
Things will break here because there is no corresponding service for this pod and consul will try to connect-inject it.
Run:
```bash
make delete-metrics-pod
```

### Check the metrics pod status
Now when this pod restarts consul will attempt to connect-inject it. Run:
```bash
make metrics-pod-status
```

Now you should see something like (note now there are 3 containers in the pod)
```
NAME                   READY   STATUS     RESTARTS       AGE
kube-state-metrics-0   0/3     Init:0/1   3 (104s ago)   8m6s
```

### Clean up to try again
Run the following to clean up the consul install and restart the metrics pod:
```bash
make uninstall-consul && make delete-metrics-pod
```

### Install consul using local charts
Run the following to install consul using your local version of the consul-k8s charts (ensure your `CONSUL_K8S_CHARTS_LOCATION` is set):
```bash
make start-local-charts
```

### Check the metrics pod status
```bash
make metrics-pod-status
```

You should see something like 
```
NAME                   READY   STATUS    RESTARTS   AGE
kube-state-metrics-0   2/2     Running   0          2m43s
```

### Restart the metrics pod
Things will no longer break here because we have told consul to ignore connect-injecting this namespace.
Run:
```bash
make delete-metrics-pod
```

### Check the metrics pod status
Now when this pod restarts consul will attempt to connect-inject it. Run:
```bash
make metrics-pod-status
```

Now you should see something like (note now there are only 2 containers in the pod still and it comes up successfully)
```
NAME                   READY   STATUS    RESTARTS   AGE
kube-state-metrics-0   2/2     Running   0          2m43s
```

### Clean everything up
Let's delete all the clusters, run the following to delete everything:
```bash
make destroy
```
