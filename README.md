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
