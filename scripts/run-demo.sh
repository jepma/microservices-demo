#!/bin/bash

if [ "$(kubectl -n sock-shop get  deployments --selector=name=front-end -o jsonpath='{.items[*].metadata.labels.version}')" == "2.0.0" ]; then

    echo "Switch to 1.0.0"
    kubectl replace -f /opt/demo-files/microservices-demo/manifests-start/front-end-dep.yaml

else

    echo "Switch to 2.0.0"
    kubectl replace -f /opt/demo-files/microservices-demo/manifests-update/front-end-dep.yaml

fi

echo "Rollout status...."
kubectl rollout status deployment/front-end --namespace=sock-shop

echo "Now we sleep for 2 minutes..."
sleep 120
