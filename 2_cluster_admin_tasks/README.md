# os-tap-install

This github repository contains instructions and files required to install the app-accelerator from the Tanzu Application Platform.  These instructions have been derived and tested to install the app-acclerator in Tanzu Application Platform 1.1.0 on openshift 4.10.9.  The instructions and contents could vary depending on the version of openshift and Tanzu Application Platform version 1.2. 

NOTE: As a prerequisite to installing cluster essentials, the cluster has to have visibility to the registry you are pulling from.

# Contents 
### cluster-admin tasks
1. registry from which to install cluster essentials  
1. Create Cluster
1. grant users access, need 1 cluster-admin, 1 namespace owner
1. if you haven't yet installed yq, install it
    * yq reference: `https://github.com/mikefarah/yq`    
1. cp values-example.yaml and configure appropriately for your environment
    * need to specify registry to installed cluster_essentials from with login creds and tanzunet credentials
1. On Openshift clusters, apply SCC's for Kapp controller and TAP components
    * (execute `./2_cluster_admin_tasks/apply_openshift-SCCs.sh`)
1. Install Cluster Essentials (execute `./2_cluster_admin_tasks/install-cluster-essentials.sh <environment>`)
    * this step deploys the kapp controller and secretsgen controller components of the Tanzu cluster essentials
1. create a namespace and assign ownership to the user finishing the installation
    * (execute `./2_cluster_admin_tasks/namespace-creation.sh`)

## SCC folder, roles and role bindings: restrictive SCC's to run the app accelerators
The contents of the folder scc were derived from the security context of the deployments for the application accelerator on openshift 4.10.9 

## profile for cluster administration component installs


# uninstall instructions
kapp delete -a kapp-controller -n tanzu-cluster-essentials
