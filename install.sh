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

export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=$(yq '.tanzunet.username' < "${values_file}")
export INSTALL_REGISTRY_PASSWORD=$(yq '.tanzunet.password' < "${values_file}")

kapp deploy \
  --app tap-install-ns \
  --file <(\
    kubectl create namespace tap-install \
      --dry-run=client \
      --output=yaml \
      --save-config \
    ) \
  --yes

tanzu secret registry \
  --namespace tap-install \
  add tap-registry \
  --username "${INSTALL_REGISTRY_USERNAME}" \
  --password "${INSTALL_REGISTRY_PASSWORD}" \
  --server "${INSTALL_REGISTRY_HOSTNAME}" \
  --export-to-all-namespaces \
  --yes

tanzu package repository \
  --namespace tap-install \
  add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.1.0

tanzu package repository \
  --namespace tap-install \
  get tanzu-tap-repository

ytt -f "${script_dir}/profile/tap-values.yaml" -f "${values_file}" --ignore-unknown-comments > "${generated_dir}/tap-values.yaml"

tanzu package install tap \
  --namespace tap-install \
  --package-name tap.tanzu.vmware.com \
  --version 1.1.0 \
  --values-file "${generated_dir}/tap-values.yaml"


