# Microservices - Demo

Configure DEMO environment with all the elements necessary for the microservices demo appliction. This demo is a subset of the WeaveWorks Socks Webshop so all kudos go to them!

## Start with minikube

```
$ minikube start --memory 6144
$ kubectl config set-context $(kubectl config current-context) --namespace=sock-shop
```

## Start Azure DEMO

```bash
$ sudo ssh -A -o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q mjepma@dem-jumphost-appfactory0.westeurope.cloudapp.azure.com" mjepma@k8smaster0  -L 8079:ldap-ui.platform.svc.appfactory.local:80  -L 5516:xlrelease.platform.svc.appfactory.local:5516 -L 8081:jenkins.platform.svc.appfactory.local:80 -L 8083:nexus.platform.svc.appfactory.local:8081 -L 443:10.0.0.7:443 -L 80:10.0.0.7:80
```

Now, we alter our hosts file (on OSX: `/private/etc/hosts`) so it has the correct hostname.

```hosts
127.0.0.1        demo.5bd1269b11fc4c7c128e.kpnappfactory.nl
```

Now we are possible to connect to: `http://demo.5bd1269b11fc4c7c128e.kpnappfactory.nl/`

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

## LST

First we have to connect to the jumphost; we will use these resources to generate load.

```bash
ssh mjepma@dem-jumphost-appfactory0.westeurope.cloudapp.azure.com
```

Then, we have to alter the hosts file so it has this line:

```
10.0.0.7        demo.5bd1269b11fc4c7c128e.kpnappfactory.nl
```

So now we know howto contact the actual application, we can configure the loadtest:

> As you can see in the snippet; we have to use the network-configuration of our host `--net=host`

```
$ docker run --net=host --rm weaveworksdemos/load-test -d 5 -h demo.5bd1269b11fc4c7c128e.kpnappfactory.nl -c 2 -r 100
```