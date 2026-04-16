# Install Plan Approver

Deploys an installplan approver job into the `multicluster-engine` namespace.

This is required because the `MultiClusterHub` deploys the `multicluster-engine` subscription with manual approval.

Syncing at wave 5 to come after the instantiation of the `MultiClusterHub` CR.