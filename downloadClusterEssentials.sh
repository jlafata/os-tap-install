#!/bin/bash
# reference
## https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-install-air-gap.html

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}
[ -z "$1" ]            && { echo "usage: copyBits darwin | linux "; exit 1; }

case "${1:linux}" in
	darwin) PRODUCT_ID=1263761;;
	linux) PRODUCT_ID=1263760;;
esac

[ -z "$PRODUCT_ID" ]   && { echo "parameter 1 must be linux or darwin"; exit 1; }

### user must have previously logged in to pivnet with `pivnet login --api-token=<api-token>` or can download this from tanzunet manually
### see README.MD for pivnet api login instructions
echo "## downloading imgpkg cli"
pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.2.0' --product-file-id=$PRODUCT_ID
mkdir tanzu-cluster-essentials

echo "## exploding cluster essentials tar to run locally"
tar -xvf "tanzu-cluster-essentials-$1-amd64-1.2.0.tgz" -C tanzu-cluster-essentials

### cleaning up
rm tanzu-cluster-essentials-$1-amd64-1.2.0.tgz
