#!/bin/bash

ns_name=kapp-controller
echo "## Creating namespace $ns_name"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: ${ns_name}
EOF

kubectl create secret generic kapp-controller-config \
   --namespace $ns_name \
   --from-file caCerts=ca.crt
