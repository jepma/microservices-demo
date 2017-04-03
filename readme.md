# Microservices - Demo

Configure DEMO environment with all the elements necessary for the microservices demo appliction. This demo is a subset of the WeaveWorks Socks Webshop so all kudos go to them!

## Start with minikube

```
$ minikube start --memory 6144
$ kubectl config set-context $(kubectl config current-context) --namespace=sock-shop
```

## Create heapster stuff

```
$ kubectl create -f autoscaling/heapster-deployment.yaml -f autoscaling/heapster-service.yaml -f autoscaling/influxdb-deployment.yaml -f autoscaling/influxdb-service.yaml
```

## Create namespaces

```
$ kubectl create -f namespaces/sock-shop-ns.yaml -f namespaces/zipkin-ns.yaml
```

## Create demo socks shop

```
$ kubectl create -f manifests-start -f autoscaling/front-end-hsc.yaml
```

## Update image

```
$ kubectl replace -f manifests-update/front-end-dep.yaml
$ kubectl rollout status deployment/front-end --namespace=sock-shop
```

## Rollback

```
$ kubectl rollout undo deployment/front-end --namespace=sock-shop
```