#!/bin/bash

set -e
set -u
set -o pipefail

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

generated_dir="${script_dir}/generated"
mkdir -p "${generated_dir}"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}

export INSTALL_REGISTRY_HOSTNAME=$(yq '.install_registry.host' < "${values_file}")
export INSTALL_REGISTRY_USERNAME=$(yq '.install_registry.username' < "${values_file}")
export INSTALL_REGISTRY_PASSWORD=$(yq '.install_registry.password' < "${values_file}")

echo pulling from registry as $INSTALL_REGISTRY_USERNAME

export INSTALL_NAMESPACE=tap-install
../oc project $INSTALL_NAMESPACE

### must include export to all namespaces - are there other options?  not sure what the impact of "all" namespaces does
tanzu secret registry  \
  --namespace $INSTALL_NAMESPACE \
  add tap-registry \
  --username "${INSTALL_REGISTRY_USERNAME}" \
  --password "${INSTALL_REGISTRY_PASSWORD}" \
  --server "${INSTALL_REGISTRY_HOSTNAME}" \
  --export-to-all-namespaces \
  --yes --verbose 9


tanzu package repository \
  --namespace $INSTALL_NAMESPACE \
  add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.2.0

tanzu package repository \
  --namespace $INSTALL_NAMESPACE \
  get tanzu-tap-repository


ytt -f "${script_dir}/profile/tap-values.yaml" -f "${values_file}" --ignore-unknown-comments > "${generated_dir}/tap-values.yaml"

tanzu package install tap \
  --namespace $INSTALL_NAMESPACE \
  --package-name tap.tanzu.vmware.com \
  --version 1.2.0 \
  --values-file "${generated_dir}/tap-values.yaml"

exit
