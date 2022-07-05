# os-tap-install

This github repository contains instructions and files required to install the app-accelerator from the Tanzu Application Platform.  These instructions have been derived and tested to install the app-acclerator in Tanzu Application Platform 1.1.0 on openshift 4.10.9.  The instructions and contents could vary depending on the version of openshift and Tanzu Application Platform. 

# Contents 
## High level summary of install process
1. Create Cluster
1. Copy bits to your registry 
1. install pre-requisite cli tools: yq and pivnet cli
1. Install CLI components (execute `./install-cli.sh <environment>`, where environment = linux | darwin) 
1. Apply SCC's Roles and Role Bindings [scc folder](scc)
1. cp values-example.yaml and configure appropriately for your environment
1. Install Cluster Essentials (execute `./install-cluster-essentials.sh <environment>`, where environment = linux | darwin)
1. Install App Accelerator (execute `install.sh` using the profile specified in tap-values.yaml and values.yaml in the [profile](profile) folder )

## SCC folder, roles and role bindings: restrictive SCC's to run the app accelerators
The contents of the folder scc were derived from the security context of the deployments for the application accelerator on openshift 4.10.9 

## profile folder, profile and configuration values used to install the App Accelerator