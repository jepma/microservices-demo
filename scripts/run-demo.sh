#!/bin/bash

if [ "$(kubectl -n sock-shop get  deployments --selector=name=front-end -o jsonpath='{.items[*].metadata.labels.version}')" == "2.0.0" ]; then

    echo "Switch to 1.0.0"

else

    echo "Switch to 2.0.0"

fi
