# ZTP GitOps

This directory defines the `ztp-gitops` ArgoCD instance, its ApplicationSets,
and the RBAC configuration for the ZTP workflow.

Git repository credential secrets for the `ztp-gitops` namespace must be
provisioned before the ApplicationSets can sync. See
[docs/secrets-inventory.md](../../../docs/secrets-inventory.md) for the required
secrets (`policies-repo-secret`, `siteconfig-repo-secret`).

The ArgoCD instance is configured with init containers that provide the ZTP
SiteConfig and PolicyGenerator kustomize plugins.
