# example-ocp-gitops-base

Hub cluster bootstrap for OpenShift GitOps. This repository configures OpenShift GitOps (Argo CD) instances, applies an app-of-apps pattern, and defines ApplicationSets that watch the companion **example-ocp-policies** and **example-ocp-ztp** repositories so fleet policy and ZTP content are reconciled from Git.

## Prerequisites

- OpenShift Container Platform **4.16** or later on the management (hub) cluster
- Red Hat Advanced Cluster Management **2.12** or later
- **OpenShift GitOps** operator installed (or equivalent supported GitOps operator deployment aligned with this reference)

Review operator versions against your support matrix before production use.

## Repository layout

Management cluster automation is staged under `0-mgt-clusters/` (Vault, GitOps init, ACM-related bases). The GitOps-facing entry point for policies and ZTP is **`6-openshift-gitops/`**:

- **`6-openshift-gitops/applications/`**  
  Root Argo CD `Application` resources (app-of-apps) that deploy the ZTP GitOps stack and related wiring. Properties such as repository URLs are supplied via `gitops.properties` in this tree.

- **`6-openshift-gitops/ztp-gitops/`**  
  Dedicated GitOps namespace and Argo CD instance configuration for ZTP-oriented workloads, including:
  - **`policies-apps/`** — Applications and ApplicationSets that target the policies Git repository
  - **`clusters-apps/`** — ApplicationSets that target the ZTP Git repository for cluster/site content  
  Each subdirectory includes its own `gitops.properties` for repo URL and branch parameters consumed by Kustomize.

Together, these paths implement the hub-side pattern: bootstrap GitOps, then let ApplicationSets fan out to the policies and ZTP repos.

## How to adapt this reference

1. **Repository URLs and branches**  
   Replace placeholder values in `gitops.properties` files under `6-openshift-gitops/` (including `applications/`, `ztp-gitops/policies-apps/`, and `ztp-gitops/clusters-apps/`) so they reference your forks or internal mirrors of the policies and ZTP repositories.

2. **Namespaces and instance names**  
   Align Argo CD instance namespaces, `AppProject` names, and RBAC with your cluster standards. Update manifests under `6-openshift-gitops/ztp-gitops/` and any cross-references in `0-mgt-clusters/` if you change default namespace conventions.

3. **Secrets and credentials**  
   Git credentials, TLS materials, and integration with secret stores must match your environment. See [docs/secrets-inventory.md](docs/secrets-inventory.md) for items this reference expects to exist or be substituted.

4. **Hub bootstrap sequence**  
   Follow staged deployment under `0-mgt-clusters/` (for example `deploy.sh` and per-stage READMEs) only after adjusting the above for your environment.

## Related repositories

- [example-ocp-policies](https://github.com/openshift-gitops-reference/example-ocp-policies) — ACM PolicyGenerator fleet policies
- [example-ocp-ztp](https://github.com/openshift-gitops-reference/example-ocp-ztp) — ZTP site configs and cluster-specific inputs

## Further reading

- [docs/architecture.md](docs/architecture.md) — End-to-end architecture and repository relationships
- [docs/secrets-inventory.md](docs/secrets-inventory.md) — Expected secrets and configuration surfaces
