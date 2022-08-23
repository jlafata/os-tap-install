# Contents

### air-gapped preparation tasks
1. identify internal registry to copy bits to for air-gapped install 
1. cp values-example.yaml and configure appropriately for your environment
    * need to specify airgapped_registry host(with repository) and creds and tanzunet credentials
1. login to pivnet via pivnet cli `pivnet login --api-token=<api-token>`
    * Refer to the [official docs](https://network.tanzu.vmware.com/docs/api#how-to-authenticate) for more details on obtaining a Pivotal Network API token.
1. Copy bits to your registry, (execute `./2_cluster_admin_tasks/copyBits.sh <environment>, where environment = linux | darwin)

### profile folder
Contains configuration values used to copy the components to your registry