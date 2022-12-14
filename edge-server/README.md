### 1.) Upload the client server cert and key (run from certificates folder)
    kubectl create secret generic client-tls --from-file=client.crt=./edge1.crt --from-file=client.key=./edge1.key --from-file=ca.crt=./root.crt

### 2.) Install the grafana agent operator
    helm install grafana-agent-op grafana/grafana-agent-operator --create-namespace --namespace grafana-agent-op

### 3.) Update grafana-agent.yaml with the name of your cluster (this will be applied to your metrics so you can filter by cluster)

### 4.) Create a Grafana agent
    kubectl apply -f ./grafana-agent.yaml

### 5.) Update grafana-agent-metrics-instance.yaml with your mimir ingress write url (ie: http://1.2.3.4.nip.io/api/v1/push)

### 6.) Create a metrics instance
    kubectl apply -f ./grafana-agent-metrics-instance.yaml

### 7.) Create some service monitors to grab metrics from kubelet and cAdvisor
    kubectl apply -f ./kubelet-service-monitors.yaml

### 8.) Setup node exporter
    kubectl apply -f ./node-exporter.yaml

### 9.) Setup stress pods (OPTIONAL - Will generate some load on your cluster)
    kubectl apply -f ./stress-cpu.yaml
    kubectl apply -f ./stress-ram.yaml