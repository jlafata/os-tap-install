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

# replace with openshift command line project creation... which grants some privileges as well
#kapp deploy \
#  --app tap-install-ns \
#  --file <(\
#    kubectl create namespace tap-install \
#      --dry-run=client \
#      --output=yaml \
#      --save-config \
#    ) \
#  --yes

#echo "not sure if tap-install namespace exists or i don't have access to it, FIND OUT if it exists"

export INSTALL_NAMESPACE=tap-install
../oc project $INSTALL_NAMESPACE

### doesn't work without export to all namespaces - are there other options?  not sure what the impact of "all" namespaces does
tanzu secret registry  \
  --namespace $INSTALL_NAMESPACE \
  add tap-registry \
  --username "${INSTALL_REGISTRY_USERNAME}" \
  --password "${INSTALL_REGISTRY_PASSWORD}" \
  --server "${INSTALL_REGISTRY_HOSTNAME}" \
  --export-to-all-namespaces \
  --yes --verbose 9
## ok, success in project created by user
#exit
#without --export-to-all-namespaces
#Error: failed to get existing secret export in the cluster: secretexports.secretgen.carvel.dev "tap-registry" is forbidden: User "johnlafata" cannot get resource "secretexports" in API group "secretgen.carvel.dev" in the namespace "tap-install"
#with --export-to-all-namespaces
#Error: failed to create SecretExport resource: secretexports.secretgen.carvel.dev is forbidden: User "johnlafata" cannot create resource "secretexports" in API group "secretgen.carvel.dev" in the namespace "test"


tanzu package repository \
  --namespace $INSTALL_NAMESPACE \
  add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.2.0
#Error: packagerepositories.packaging.carvel.dev "tanzu-tap-repository" is forbidden: User "johnlafata" cannot get resource "packagerepositories" in API group "packaging.carvel.dev" in the namespace "test": RBAC: clusterrole.rbac.authorization.k8s.io "tap-install-os-cluster-role" not found
#Error: failed to list package repositories: packagerepositories.packaging.carvel.dev is forbidden: User "johnlafata" cannot list resource "packagerepositories" in API group "packaging.carvel.dev" in the namespace "test": RBAC: clusterrole.rbac.authorization.k8s.io "tap-install-os-cluster-role" not found
#Error: failed to create package repository 'tanzu-tap-repository' in namespace 'test': packagerepositories.packaging.carvel.dev is forbidden: User "johnlafata" cannot create resource "packagerepositories" in API group "packaging.carvel.dev" in the namespace "test": RBAC: clusterrole.rbac.authorization.k8s.io "tap-install-os-cluster-role" not found
## permissions fixed above
##      UNAUTHORIZED: unauthorized to access repository: tanzu-application-platform/tap-packages, action: pull: unauthorized to access repository: tanzu-application-platform/tap-packages, action: pull
## oc project $INSTALL_NAMESPACE fixed above

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
#### tanzu package install attempts to create a cluster role with these RBAC roles
####    namespace owner needs this role in order to grant it?
#apiVersion: rbac.authorization.k8s.io/v1
#kind: ClusterRole
#metadata:
#  annotations:
#    tkg.tanzu.vmware.com/tanzu-package: tap-tap-install
#  name: tap-tap-install-cluster-role
#rules:
#- apiGroups:
#  - '*'
#  resources:
#  - '*'
#  verbs:
#  - '*'
#---
#apiVersion: rbac.authorization.k8s.io/v1
#kind: ClusterRoleBinding
#metadata:
#  annotations:
#    tkg.tanzu.vmware.com/tanzu-package: tap-tap-install
#  creationTimestamp: "2022-07-28T11:46:11Z"
#  name: tap-tap-install-cluster-rolebinding
#  resourceVersion: "93458"
#  uid: 35362a64-493c-4029-9493-5c72812ad761
#roleRef:
#  apiGroup: rbac.authorization.k8s.io
#  kind: ClusterRole
#  name: tap-tap-install-cluster-role
#subjects:
#- kind: ServiceAccount
#  name: tap-tap-install-sa
#  namespace: tap-install

#results of execution with above clusterrole granted
#  NAME                      PACKAGE-NAME                               PACKAGE-VERSION  STATUS               NAMESPACE
#  accelerator               accelerator.apps.tanzu.vmware.com          1.2.1            Reconcile succeeded  tap-install
#  api-portal                api-portal.tanzu.vmware.com                1.0.21           Reconcile succeeded  tap-install
#  appliveview               backend.appliveview.tanzu.vmware.com       1.2.0            Reconcile succeeded  tap-install
#  cert-manager              cert-manager.tanzu.vmware.com              1.5.3+tap.2      Reconcile succeeded  tap-install
#  contour                   contour.tanzu.vmware.com                   1.18.2+tap.2     Reconcile succeeded  tap-install
#  fluxcd-source-controller  fluxcd.source.controller.tanzu.vmware.com  0.16.4           Reconcile succeeded  tap-install
#  source-controller         controller.source.apps.tanzu.vmware.com    0.4.1            Reconcile succeeded  tap-install
#  tap                       tap.tanzu.vmware.com                       1.2.0            Reconcile succeeded  tap-install
#  tap-gui                   tap-gui.tanzu.vmware.com                   1.2.3            Reconcile succeeded  tap-install
#  tap-telemetry             tap-telemetry.tanzu.vmware.com             0.2.0            Reconcile succeeded  tap-install
