### 1.) Add nginx ingress helm chart repo
    helm repo add nginx-stable https://helm.nginx.com/stable
    helm repo update

### 2.) Install nginx ingress:
    helm install ingress-nginx ingress-nginx/ingress-nginx --create-namespace --namespace ingress-nginx --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz

### 3.) Add the grafana labs helm chart repo:
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update

### 4.) Create the mimir namespace
    kubectl create ns mimir

### 5.) Add the grafana agent operator (this will be used for metamonitoring of Mimir)
    helm install grafana-agent-op grafana/grafana-agent-operator -n mimir

### 6.) Update the mimir.values.yaml with your cluster's nginx ingress IP + .nip.io (ie: 1.2.3.4.nip.io), as well as your storage account information

### 7.) Create certs (make sure to use correct domain, and run from certificates folder)
    ./make-certs.sh 1.2.3.4.nip.io

### 8.) Upload the ingress server cert and key (run from certificates folder)
    kubectl create secret -n mimir generic nginx-tls --from-file=tls.crt=./server.crt --from-file=tls.key=./server.key --from-file=ca.crt=./root.crt

### 9.) Install Mimir
    helm install mimir grafana/mimir-distributed --namespace mimir -f mimir.values.yaml

### 10.) Install Grafana
    kubectl create ns grafana
    kubectl apply -f ./grafana.yaml

### 11.) Add Mimir Datasource to Grafana (http://mimir-nginx.mimir.svc:80/prometheus)

### 12.) Import the node-stats-by-cluster.json dashboard into Grafana