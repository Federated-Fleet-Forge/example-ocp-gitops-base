# Applications

This directory contains the ArgoCD Application definitions that bootstrap the
`ztp-gitops` ArgoCD instance and related resources.

## Prerequisites

Before applying, ensure that Git repository credential secrets exist in the
`openshift-gitops` namespace. See
[docs/secrets-inventory.md](../../docs/secrets-inventory.md) for the required
secret names, keys, and how to create them using your preferred secrets
management solution.

## Apply

```bash
oc apply -k .
```
