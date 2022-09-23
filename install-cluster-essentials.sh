#!/bin/bash

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}

export INSTALL_REGISTRY_HOSTNAME=$(yq '.install_registry.host' < "${values_file}")    ## for harbor must include project
export INSTALL_REGISTRY_USERNAME=$(yq '.install_registry.username' < "${values_file}")
export INSTALL_REGISTRY_PASSWORD=$(yq '.install_registry.password' < "${values_file}")

[ -z "$INSTALL_REGISTRY_HOSTNAME" ] && { echo "install_registry.host must be set in values.yaml"; exit 1; }
[ -z "$INSTALL_REGISTRY_USERNAME" ] && { echo "install_registry.username must be set in values.yaml"; exit 1; }
[ -z "$INSTALL_REGISTRY_PASSWORD" ] && { echo "install_registry.password must be set in values.yaml"; exit 1; }

# rem parameterize this
#export CLUSTER_ESSENTIALS_BUNDLE_SHA=sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e
#export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@$CLUSTER_ESSENTIALS_BUNDLE_SHA
#export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e
export INSTALL_BUNDLE=jltestcr.azurecr.io/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e


cd tanzu-cluster-essentials
./install.sh --yes
#../2_cluster_preparation_tasks/tanzu_cluster_essentials_with_overrides_install.sh --yes
cd ..
