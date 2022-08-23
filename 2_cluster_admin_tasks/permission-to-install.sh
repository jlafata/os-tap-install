#!/bin/bash

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}
#echo "creating namespace tap-install"
#
#kapp deploy  --app tap-install-ns   --file <(    kubectl create namespace tap-install --dry-run=client --output=yaml  --save-config )  --yes

kapp deploy  --app tap-install-ns-cluster-role   --file  ./2_cluster_admin_tasks/namespace-owner-cluster-role.yaml  --yes
export NAMESPACE_OWNER=$(yq '.namespace_owner.user_id' < "${values_file}")
kapp deploy  --app tap-install-ns-cluster-role-binding   --file <(   kubectl create clusterrolebinding tap-install-cluster-role-binding --clusterrole="tap-install-cluster-role" --user=$NAMESPACE_OWNER  --dry-run=client --output=yaml  --save-config )  --yes
