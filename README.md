# os-tap-install

This github repository contains instructions and files required to install the app-accelerator from the Tanzu Application Platform.  These instructions have been derived and tested to install the app-acclerator in Tanzu Application Platform 1.1.0 on openshift 4.10.9.  The instructions and contents could vary depending on the version of openshift and Tanzu Application Platform version 1.2. 

The instructions are broken out into tasks performed by 3 different personas.  These could all be performed by the same person or different people depending on how privileges are assigned in your organization.

All three personas need yq and cluster essentials cli installed
    * yq reference: `https://github.com/mikefarah/yq`    
    * to support packaging, we use imgpkg (part of the carvel tool chain)
        * accept EULA's for cluster essentials
        * you can download from tanzu net manually and unpack it into a folder as follows 
            mkdir tanzu-cluster-essentials
            tar -xvf "tanzu-cluster-essentials-$1-amd64-1.2.0.tgz" -C tanzu-cluster-essentials
        * or (execute ./downloadClusterEssentials.sh <env>, where env : linux | darwin)


## High level summary of install process
1. (optional) copy bits from Tanzu Registry to air-gapped registry 
    * see [Airgapped Preparation](./1_airgapped_preparation/README.md)
1. cluster admin tasks (create cluster and assign users/roles, add SCC's, create namespaces, install cluster essentials)
    * see [cluster Admin Tasks](./2_cluster_admin_tasks/README.md)
1. namespace owner tasks (install TAP components)
    * see [namespace owner Tasks](./2_cluster_admin_tasks/README.md)

### TODO delete the rest of this
# Contents 
### cluster-admin tasks
1. identify domain name for GUI 
1. identify internal registry to copy bits for air-gapped install 
1. Create Cluster
1. grant users access, need 1 cluster-admin, 1 namespace admin
1. install pre-requisite command line tools: yq and pivnet cli
    * pivnet reference: `https://github.com/pivotal-cf/pivnet-cli`
      * user must have previously logged in to pivnet with `pivnet login --api-token=<api-token>`
      * Refer to the [official docs](https://network.tanzu.vmware.com/docs/api#how-to-authenticate) for more details on obtaining a Pivotal Network API token.
    * yq reference: `https://github.com/mikefarah/yq`    
1. cp values-example.yaml and configure appropriately for your environment
    * need to specify airgapped_registry host(with repository) and creds and tanzunet credentials
1. login to pivnet via pivnet cli `pivnet login --api-token=<api-token>`
    * Refer to the [official docs](https://network.tanzu.vmware.com/docs/api#how-to-authenticate) for more details on obtaining a Pivotal Network API token.
1. Copy bits to your registry, (execute `./cluster-admin-tasks/copyBits.sh <environment>, where environment = linux | darwin)
1. Install CLI components (execute `./install-cli.sh <environment>`, where environment = linux | darwin) 
#### can we install cluster essentials cli without deploying to k8s (without applying scc's)... just install imgpkg ????
1. Apply SCC's Roles and Role Bindings [scc folder](2_cluster_admin_tasks/scc)
1. Install Cluster Essentials (execute `./install-cluster-essentials.sh <environment>`, where environment = linux | darwin)
#### end of section we're trying to skip

### namespace-admin tasks
1. install pre-requisite cli tools: yq and pivnet cli
# values to be provided by operator  
1. cp values-example.yaml and configure appropriately for your environment
1. Install CLI components (execute `./install-cli.sh <environment>`, where environment = linux | darwin) 
1. Install App Accelerator (execute `./install.sh` using the profile specified in tap-values.yaml and values.yaml in the [profile](2_cluster_admin_tasks/profile) folder )

## SCC folder, roles and role bindings: restrictive SCC's to run the app accelerators
The contents of the folder scc were derived from the security context of the deployments for the application accelerator on openshift 4.10.9 

