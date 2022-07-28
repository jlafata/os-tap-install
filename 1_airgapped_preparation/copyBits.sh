#!/bin/bash
# reference
## https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-install-air-gap.html

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}

[ -z "$1" ]        cd    && { echo "usage: copyBits darwin | linux "; exit 1; }


export TARGET_REPOSITORY=$(yq '.airgapped_registry.host' < "${values_file}")
export TARGET_REGISTRY_USERNAME=$(yq '.airgapped_registry.username' < "${values_file}")
export TARGET_REGISTRY_PASSWORD=$(yq '.airgapped_registry.password' < "${values_file}")
### this may only be needed if your CA is not in default trust store, i.e. custom ca,  letsencrypt ca or self-signed cert
export TARGET_REGISTRY_CA_PATH=$(yq '.airgapped_registry.ca_path' < "${values_file}")

[ -z "$TARGET_REPOSITORY" ] && { echo "airgapped_registry.host must be set in values.yaml"; exit 1; }
[ -z "$TARGET_REGISTRY_USERNAME" ] && { echo "airgapped_registry.username must be set in values.yaml"; exit 1; }
[ -z "$TARGET_REGISTRY_PASSWORD" ] && { echo "airgapped_registry.password must be set in values.yaml"; exit 1; }
### this may only be needed if your CA is not in default trust store, i.e. custom ca,  letsencrypt ca or self-signed cert
[ -z "$TARGET_REGISTRY_CA_PATH" ] && { echo "airgapped_registry.ca_path must be set in values.yaml"; exit 1; }

export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=$(yq '.tanzunet.username' < "${values_file}")
export INSTALL_REGISTRY_PASSWORD=$(yq '.tanzunet.password' < "${values_file}")

[ -z "$INSTALL_REGISTRY_USERNAME" ] && { echo "tanzunet.username must be set in values.yaml"; exit 1; }
[ -z "$INSTALL_REGISTRY_PASSWORD" ] && { echo "tanzunet.password must be set in values.yaml"; exit 1; }

export TAP_VERSION=1.2.0
echo "## pull TAP bundle from $INSTALL_REGISTRY_HOSTNAME (username: $INSTALL_REGISTRY_USERNAME)"
export IMGPKG_REGISTRY_HOSTNAME=$INSTALL_REGISTRY_HOSTNAME
export IMGPKG_REGISTRY_USERNAME=$INSTALL_REGISTRY_USERNAME
export IMGPKG_REGISTRY_PASSWORD=$INSTALL_REGISTRY_PASSWORD
./tanzu-cluster-essentials/imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION --to-tar=./tap1-2.tar  --include-non-distributable-layers

echo "## push TAP bundle to $TARGET_REPOSITORY (username: $IMGPKG_REGISTRY_USERNAME)"
export IMGPKG_REGISTRY_HOSTNAME=$TARGET_REPOSITORY
export IMGPKG_REGISTRY_USERNAME=$TARGET_REGISTRY_USERNAME
export IMGPKG_REGISTRY_PASSWORD=$TARGET_REGISTRY_PASSWORD
./tanzu-cluster-essentials/imgpkg copy --tar ./tap1-2.tar --to-repo=$TARGET_REPOSITORY/tap1-2   --include-non-distributable-layers  --registry-ca-cert-path $TARGET_REGISTRY_CA_PATH

echo "## pull Cluster essentials bundle from $INSTALL_REGISTRY_HOSTNAME (username: $INSTALL_REGISTRY_USERNAME)"
export IMGPKG_REGISTRY_HOSTNAME=$INSTALL_REGISTRY_HOSTNAME
export IMGPKG_REGISTRY_USERNAME=$INSTALL_REGISTRY_USERNAME
export IMGPKG_REGISTRY_PASSWORD=$INSTALL_REGISTRY_PASSWORD
./tanzu-cluster-essentials/imgpkg copy -b registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e --to-tar=./tanzu-cluster-essentials1-2.tar      --include-non-distributable-layers
echo "## push Cluster essentials bundle to $TARGET_REPOSITORY (username: $IMGPKG_REGISTRY_USERNAME)"
export IMGPKG_REGISTRY_HOSTNAME=$TARGET_REPOSITORY
export IMGPKG_REGISTRY_USERNAME=$TARGET_REGISTRY_USERNAME
export IMGPKG_REGISTRY_PASSWORD=$TARGET_REGISTRY_PASSWORD
./tanzu-cluster-essentials/imgpkg copy --tar ./tanzu-cluster-essentials1-2.tar --to-repo=$TARGET_REPOSITORY/cluster-essentials-bundle      --include-non-distributable-layers  --registry-ca-cert-path $TARGET_REGISTRY_CA_PATH

echo "cleaning up"
rm tanzu-cluster-essentials-$1-amd64-1.2.0.tgz
rm tanzu-cluster-essentials1-2.tar
rm tap1-2.tar