# os-tap-install

This github repository contains instructions and files required to install the app-accelerator from the Tanzu Application Platform.  These instructions have been derived and tested to install the app-acclerator in Tanzu Application Platform 1.1.0 on openshift 4.10.9.  The instructions and contents could vary depending on the version of openshift and Tanzu Application Platform version 1.2. 

# Contents 



### namespace-admin tasks
1. identify domain name for GUI 
1. install pre-requisite cli tools: yq and pivnet cli
1. cp values-example.yaml and configure appropriately for your environment
1. Install CLI components (execute `./3_namespace_owner_tasks/install-cli.sh <environment>`, where environment = linux | darwin) 
1. Install App Accelerator (execute `./3_namespace_owner_tasks/install-tap-packages.sh` using the profile specified in tap-values.yaml and values.yaml in the [profile](cluster-admin-tasks/profile) folder )


## profile folder, profile and configuration values used to install the App Accelerator