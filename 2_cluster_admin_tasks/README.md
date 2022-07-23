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

### SCC folder
Contains roles and role bindings: restrictive SCC's to run the app accelerators
The contents of the folder scc were derived from the security context of the deployments for the application accelerator on openshift 4.10.9 

### profile folder
Contains configuration values used to install the Cluster Essentials

# Cluster Essentials uninstall instructions
kapp delete -a kapp-controller -n tanzu-cluster-essentials
kapp delete -a secretgen-controller -n tanzu-cluster-essentials
