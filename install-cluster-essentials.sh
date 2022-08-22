#!/bin/bash

case "${1:linux}" in
	darwin) PRODUCT_ID=1263761;;
	linux) PRODUCT_ID=1263760;;
esac
pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.2.0' --product-file-id=$PRODUCT_ID

mkdir tanzu-cluster-essentials

tar -xvf "tanzu-cluster-essentials-$1-amd64-1.2.0.tgz" -C tanzu-cluster-essentials

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=$(cat profile/values.yaml | grep tanzunet -A 3 | awk '/username:/ {print $2}')
export INSTALL_REGISTRY_PASSWORD=$(cat profile/values.yaml  | grep tanzunet -A 3 | awk '/password:/ {print $2}')

cd tanzu-cluster-essentials
./install.sh --yes
cd ..
