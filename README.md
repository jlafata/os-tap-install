# os-tap-install

This github repository contains instructions and files required to install the app-accelerator from the Tanzu Application Platform.  These instructions have been derived and tested to install the app-acclerator in Tanzu Application Platform 1.2.0 on openshift 4.10.9.  The instructions and contents could vary depending on the version of openshift and Tanzu Application Platform version. 

The instructions are broken out into tasks performed by 3 different personas: airgapped registry authority, cluster admin and namespace owner.  These could all be performed by the same person or different people depending on how privileges are assigned in your organization.

All three personas need yq and cluster essentials cli installed
    
    * YQ is a tool to parse yaml files: to install yq, refer to this url 
        https://github.com/mikefarah/yq    
    
    * VMware packages software components use imgpkg (part of the carvel tool chain, also known as Cluster Essentials). Cluster Essentials must be installed to retrieve the bundled components for installation in your environment.
    
        * accept EULA's for cluster essentials
    
        * you can download from tanzu net manually and unpack it into a folder as follows 
    
            mkdir tanzu-cluster-essentials
    
            tar -xvf "tanzu-cluster-essentials-$1-amd64-1.2.0.tgz" -C tanzu-cluster-essentials
    
        * or (execute ./downloadClusterEssentials.sh <env>, where env : linux | darwin)


## High level summary of install process
1. (optional) copy bits from Tanzu Registry to air-gapped registry 
    * see [Airgapped Preparation](./1_airgapped_preparation/README.md)
1. cluster admin tasks (create cluster, add SCC's, create namespaces, assign users/roles )
    * see [cluster Admin Tasks](./2_cluster_admin_tasks/README.md)
1. namespace owner tasks (install TAP components)
    * see [namespace owner Tasks](./2_cluster_admin_tasks/README.md)

