#!/bin/bash
echo "adding SCC's required for Openshift install"
kubectl apply -f 2_cluster_admin_tasks/scc
