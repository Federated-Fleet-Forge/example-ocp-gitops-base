# CRC Hub Bootstrap

Bootstrap a CRC (OpenShift Local) hub cluster with OpenShift GitOps (ArgoCD)
and ACM 2.16 for ZTP-based spoke cluster provisioning.

## Prerequisites

- CRC running (`crc start`) and `oc` logged in as kubeadmin
- Pull secret at `~/pull-secret.json`
- Git repo URLs updated in:
  - `3-gitops-init/git-secrets.yaml`
  - `4-openshift-gitops/gitops.properties`

## Stages

| Stage | Directory | What it deploys |
|-------|-----------|-----------------|
| 3 | `3-gitops-init/` | OpenShift GitOps operator, RBAC, Git repo secrets, installplan approver |
| 4 | `4-openshift-gitops/` | ArgoCD instance (`gitops-root`), root Application for ZTP stack, ACM Application |
| 5 | `5-root-apps/` | ACM operator (2.16), MultiClusterHub, TALM, metal3 Provisioning (synced by ArgoCD) |

## Deploy

```bash
oc login -u kubeadmin https://api.crc.testing:6443
cd 0-mgt-clusters
./deploy.sh
```

## Delete

```bash
./delete.sh
```
