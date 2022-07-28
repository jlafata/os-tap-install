#!/bin/bash

[ -z "$1" ]            && { echo "usage: install-cli darwin | linux "; exit 1; }

case "${1:linux}" in
	darwin) PRODUCT_ID="found";;
	linux) PRODUCT_ID="found";;
esac

[ -z "$PRODUCT_ID" ]   && { echo "parameter 1 must be linux or darwin"; exit 1; }

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}

#export IMGPKG_REGISTRY_HOSTNAME=$(yq '.install_registry.host' < "${values_file}")    ## for harbor must include project
#export IMGPKG_REGISTRY_USERNAME=$(yq '.install_registry.username' < "${values_file}")
#export IMGPKG_REGISTRY_PASSWORD=$(yq '.install_registry.password' < "${values_file}")
#### this may only be needed if your CA is not in default trust store, i.e. custom ca,  letsencrypt ca or self-signed cert
##export INSTALL_REGISTRY_CA_PATH=$(yq '.install_registry.ca_path' < "${values_file}")
#
#[ -z "$IMGPKG_REGISTRY_HOSTNAME" ] && { echo "install_registry.host must be set in values.yaml"; exit 1; }
#[ -z "$IMGPKG_REGISTRY_USERNAME" ] && { echo "install_registry.username must be set in values.yaml"; exit 1; }
#[ -z "$IMGPKG_REGISTRY_PASSWORD" ] && { echo "install_registry.password must be set in values.yaml"; exit 1; }
#### this may only be needed if your CA is not in default trust store, i.e. custom ca,  letsencrypt ca or self-signed cert
##[ -z "$TARGET_REGISTRY_CA_PATH" ] && { echo "airgapped_registry.ca_path must be set in values.yaml"; exit 1; }
#
#export TAP_VERSION=1.2
#export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:$TAP_VERSION
##working from cluster_essentials file- DELETE THIS AND NEXT LINE
##export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e
#
## ??? pull the package with it's take to extact the bundle
##./tanzu-cluster-essentials/imgpkg pull -b $INSTALL_BUNDLE --registry-ca-cert-path $INSTALL_REGISTRY_CA_PATH  -o ./bundle/
#./tanzu-cluster-essentials/imgpkg pull -b $INSTALL_BUNDLE   -o ./bundle/
##WORKING FROM tanzu_cluster_essentials/install.sh
#echo "extract just the tar file for tanzu cli"
#
#
##pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.2.0' --product-file-id=$PRODUCT_ID
#exit
#

mkdir tanzu
tar -xvf "tanzu-framework-$1-amd64.tar" -C tanzu
export TANZU_CLI_NO_INIT=true
cd tanzu
#1.1
#sudo install "cli/core/v0.11.2/tanzu-core-$1_amd64" /usr/local/bin/tanzu
#1.2
sudo install "cli/core/v0.11.6/tanzu-core-$1_amd64" /usr/local/bin/tanzu
tanzu version

tanzu plugin install --local cli all
tanzu plugin list
cd ..



### edits

#!/bin/bash

case "${1:linux}" in
	darwin) PRODUCT_ID=1246418;;
	linux) PRODUCT_ID=1246421;;
esac

[ -z "$PRODUCT_ID" ]   && { echo "parameter 1 must be linux or darwin"; exit 1; }

export INSTALL_REGISTRY_HOSTNAME=$(yq '.install_registry.host' < "${values_file}")    ## for harbor must include project
export INSTALL_REGISTRY_USERNAME=$(yq '.install_registry.username' < "${values_file}")
export INSTALL_REGISTRY_PASSWORD=$(yq '.install_registry.password' < "${values_file}")
### this may only be needed if your CA is not in default trust store, i.e. custom ca,  letsencrypt ca or self-signed cert
#export INSTALL_REGISTRY_CA_PATH=$(yq '.install_registry.ca_path' < "${values_file}")

[ -z "$INSTALL_REGISTRY_HOSTNAME" ] && { echo "install_registry.host must be set in values.yaml"; exit 1; }
[ -z "$INSTALL_REGISTRY_USERNAME" ] && { echo "install_registry.username must be set in values.yaml"; exit 1; }
[ -z "$INSTALL_REGISTRY_PASSWORD" ] && { echo "install_registry.password must be set in values.yaml"; exit 1; }
### this may only be needed if your CA is not in default trust store, i.e. custom ca,  letsencrypt ca or self-signed cert
#[ -z "$TARGET_REGISTRY_CA_PATH" ] && { echo "airgapped_registry.ca_path must be set in values.yaml"; exit 1; }

./tanzu-cluster-essentials/imgpkg copy -b $INSTALL_REGISTRY_HOSTNAME/tap1-2/ --to-tar=./tap1-2.tar

mkdir tanzu
tar -xvf "tanzu-framework-$1-amd64.tar" -C tanzu
export TANZU_CLI_NO_INIT=true
cd tanzu
sudo install "cli/core/v0.11.6/tanzu-core-$1_amd64" /usr/local/bin/tanzu
tanzu version

tanzu plugin install --local cli all
tanzu plugin list
cd ..

