# kubernetes-devops-security

## Fork and Clone this Repo

## Clone to Desktop and VM

## NodeJS Microservice - Docker Image -
`docker run -p 8787:5000 siddharth67/node-service:v1`

`curl localhost:8787/plusone/99`
 
## NodeJS Microservice - Kubernetes Deployment -
`kubectl -n default create  deploy node-app --image siddharth67/node-service:v1`

`kubectl -n default  expose  deploy node-app --name node-service --port 5000 --type ClusterIP`

`curl node-service-ip:5000/plusone/99`

## sonarqube image 

'docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest'

## cis benchmarking

https://www.cisecurity.org/benchmark/kubernetes


download kube-bench


https://github.com/aquasecurity/kube-bench


curl -L https://github.com/aquasecurity/kube-bench/releases/download/v0.6.10/kube-bench_0.6.10_linux_amd64.deb -o kube-bench_0.6.10_linux_amd64.deb

sudo apt install ./kube-bench_0.6.10_linux_amd64.deb -f
(run as root user)
 kube-bench

fix for 1.1.12

useradd etcd
chown etcd:etcd /var/lib/etcd


## istio installation

curl -L https://istio.io/downloadIstio | sh -

cd istio-1.15.2
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y

kubectl apply -f samples/addons


# view kiali dashboard 
  kubectl -n istio-system edit svc kiali

  change type: ClusterIp to NodePort

## injecting sidecar container 

# automatic injection 
kubectl label namespace <name> istio-injection=enabled

# manual way 
kubectl apply -f <(istioctl kube-inject -f k8s.yaml)

kubectl create ns prod
kubectl -n prod create deploy node-app --image siddharth67/node-service:v1
kubectl -n prod expose deploy node-app --name node-service --port 5000
kubectl get namespace --show-labels
kubectl label na prod istio-injection=enabled
kubectl -n prod rollout restart deploy node-app

## mtls
 # PeerAuthentication
 cat > peerauth.yml <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT

EOF

kubectl apply -f peerauth.yml

 # Configuring ingress using an Istio gateway

 cat > istio-gateway-vs.yaml <<EOF
 ---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: devsecops-gateway
  namespace: prod
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - '*'
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: devsecops-numeric
  namespace: prod
spec:
  hosts:
  - "*"
  gateways:
  - devsecops-gateway
  http:
  - match:
    - uri:
        prefix: /increment
    - uri:
        exact: /
    route:
    - destination:
        port:
          number: 8000
        host: devsecops-svc

EOF


kubectl get vs,gateway -n prod

kubectl get 

 while true; do curl -s localhost:31130/increment/99;leep 1; done
http://ec2-52-90-156-55.compute-1.amazonaws.com:31130/

## monitoring 

enable prometheus and grafana NOdePort

## install falco
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
apt-get -y install linux-headers-$(uname -r)
apt-get install -y falco


## install helm

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

## install falcosidekik

kubectl create namespace falco
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm install falco falcosecurity/falco \
--set falcosidekick.enabled=true \
--set falcosidekick.webui.enabled=true -n falco

helm repo ls

https://hooks.slack.com/services/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

curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/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


kubectl create namespace falco
helm repo add falcosecurity https://falcosecurity.github.io/charts



## kube-scan 

kubectl apply -f https://raw.githubusercontent.com/sidd-harth/kubernetes-devops-security/main/kube-scan.yaml



### custom slack app    


create new app

xoxb-4263304883700-4263781523138-aCIvB62YpsZ3zx3lmNzmjgdG