# Secrets inventory

This reference solution does **not** embed a single secrets backend. All sensitive material is represented as standard **Kubernetes `Secret` resources** (or values pulled into policies via hub `Secret` lookups where documented in the policy generators). You choose how those objects are created and rotated.

Common approaches:

- **HashiCorp Vault** with [Vault Secrets Operator](https://github.com/hashicorp/vault-secrets-operator) or similar sync to Kubernetes
- **Sealed Secrets** (Bitnami) for Git-friendly encrypted secrets
- **External Secrets Operator** with AWS Secrets Manager, Azure Key Vault, Google Secret Manager, or other providers
- **Cloud-native stores** (AWS Secrets Manager, Azure Key Vault) feeding the cluster via automation
- **CI/CD or runbooks** that apply secrets from a secure pipeline
- **Manual** `kubectl create secret` / YAML apply for labs (not recommended for production long term)

Before first sync of Argo CD or first ZTP install, ensure the secrets below exist with the expected keys. Namespace names may include per-cluster namespaces for ZTP (for example one namespace per site or cluster); the table calls that out where applicable.

---

## Required Kubernetes secrets

| Secret name | Namespace | Keys | Purpose | Used by |
| --- | --- | --- | --- | --- |
| `gitops-base-repo-secret` | `openshift-gitops` | `type`, `url`, `username`, `password` | Git credentials for the gitops-base repository | Argo CD (`openshift-gitops`) |
| `policies-repo-secret` | `ztp-gitops` | `type`, `url`, `username`, `password` | Git credentials for the policies repository | Argo CD (`ztp-gitops`) |
| `siteconfig-repo-secret` | `ztp-gitops` | `type`, `url`, `username`, `password` | Git credentials for the ZTP / siteconfig repository | Argo CD (`ztp-gitops`) |
| `bmh-secret` | Per cluster namespace (ZTP) | `username`, `password` | BMC credentials for bare metal hosts | ZTP / Agent-based installer (`BareMetalHost`) |
| `pull-secret` | Per cluster namespace (ZTP) | `.dockerconfigjson` | OpenShift pull secret for cluster install | ZTP / Agent-based installer |
| `pull-secret-workload-clusters` | Per cluster namespace (ZTP) | `.dockerconfigjson` | Workload / additional registry pull configuration | ZTP / Agent-based installer, image pulls |
| `ldap-bind-password` | `policies` (hub) | `bindPassword` | LDAP bind password for directory integration | LDAP group sync `CronJob`, OAuth identity provider policy |
| `alertmanager-secrets` | `policies` (hub) | *(varies; e.g. SMTP and recipient fields referenced by policy templates)* | Alertmanager notification configuration | Cluster monitoring / Alertmanager policy |
| `api-tlscert` | Per cluster namespace | `tls.crt`, `tls.key` | API server TLS certificate material | API server configuration policy |
| `apps-tlscert` | Per cluster namespace | `tls.crt`, `tls.key` | Ingress / applications TLS certificate material | Ingress / router configuration policy |
| `breakglass-admin-<cluster>` | `policies` (hub) | `htpasswd` | Emergency break-glass admin (`htpasswd` data) | Breakglass / compliance policy per managed cluster |

**Notes:**

- Argo CD repository secrets must include the label `argocd.argoproj.io/secret-type: repository` so Argo CD discovers them (see example below).
- Per-cluster secret names such as `breakglass-admin-<cluster>` align with managed cluster names in policy templates.
- Some policies use hub-side `fromSecret` or `lookup` helpers; keep hub secrets in the namespace expected by your PolicyGenerator manifests (often `policies` for shared fleet secrets).

---

## Example: create a Git repository secret manually

Replace `<GIT_USERNAME>` and `<GIT_TOKEN>` with a service account or token that has read access to the repository.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: gitops-base-repo-secret
  namespace: openshift-gitops
  labels:
    argocd.argoproj.io/secret-type: repository
type: Opaque
stringData:
  type: git
  url: https://github.com/dusty-seahorse/example-ocp-gitops-base
  username: <GIT_USERNAME>
  password: <GIT_TOKEN>
```

Apply the same pattern for `policies-repo-secret` and `siteconfig-repo-secret` in the `ztp-gitops` namespace, changing `metadata.name`, `metadata.namespace`, and `stringData.url` to match each repository:

- `https://github.com/dusty-seahorse/example-ocp-policies`
- `https://github.com/dusty-seahorse/example-ocp-ztp`
