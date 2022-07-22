#!/bin/bash

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}
echo "creating namespace tap-install"

kapp deploy  --app tap-install-ns   --file <(    kubectl create namespace tap-install --dry-run=client --output=yaml  --save-config )  --yes

# kubectl create role tap-install-role

export NAMESPACE_OWNER=$(yq '.namespace_owner.user_id' < "${values_file}")    ## for harbor must include project
# kubectl create rolebinding tap-install-role-binding