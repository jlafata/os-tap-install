# Contents 

Tanzu Application platform components are installed via with Tanzu CLI. 

## namespace-admin tasks
1. identify domain name for GUI 
1. cp values-example.yaml and configure appropriately for your environment
1. Download Tanzu CLI components  [ this can be done ahead of time ]
    * (execute `./3_namespace_owner_tasks/downloadTanzuCLI.sh <environment>`, where environment = linux | darwin) 
1. Install Tanzu CLI components (execute `./3_namespace_owner_tasks/installTanzuCLI.sh <environment>`, where environment = linux | darwin)
1. create project (or namespace)  (execute `./3_namespace_owner_tasks/namespace-create.sh` )
1. Install App Accelerator (execute `./3_namespace_owner_tasks/install-tap-packages.sh` using the profile specified in tap-values.yaml and values.yaml in the [profile](3_namespace_owner_tasks/profile) folder )

### profile folder
Contains profile and configuration values used to install the App Accelerator