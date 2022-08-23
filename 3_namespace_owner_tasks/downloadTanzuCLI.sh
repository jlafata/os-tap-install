#!/bin/bash
# reference
## https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-install-air-gap.html

# base everything relative to the directory of this script file
script_dir="$(cd $(dirname "$BASH_SOURCE[0]") && pwd)"

values_file_default="${script_dir}/profile/values.yaml"
values_file=${VALUES_FILE:-$values_file_default}
[ -z "$1" ]            && { echo "usage: downloadTanzuCLI.sh darwin | linux "; exit 1; }

case "${1:linux}" in
	darwin) PRODUCT_ID=1246418;;
	linux) PRODUCT_ID=1246421;;
esac

[ -z "$PRODUCT_ID" ]   && { echo "parameter 1 must be linux or darwin"; exit 1; }

### user must have previously logged in to pivnet with `pivnet login --api-token=<api-token>` or can download this from tanzunet manually
### see README.MD for pivnet api login instructions
echo "## downloading tanzu framework cli"
pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.2.1' --product-file-id=$PRODUCT_ID

