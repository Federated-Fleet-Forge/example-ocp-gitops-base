#!/bin/bash
# Bootstrap CRC hub with OpenShift GitOps and ACM.
#
# Prerequisites:
#   - Cluster is running and 'oc' logged in as kubeadmin
#   - Git repo secrets updated in 3-gitops-init/git-secrets.yaml
#   - Repo URLs updated in 4-openshift-gitops/gitops.properties
set -euo pipefail

CLUSTER_NAME=$(oc get route -n openshift-console console -o jsonpath='{.spec.host}' | cut -d. -f3)
if [ -z "$CLUSTER_NAME" ]; then
  echo "ERROR: Cannot detect cluster name. Are you logged in? (oc login ...)"
  exit 1
fi

read -p "Targeting cluster '$CLUSTER_NAME'. Continue? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
  echo "Aborted."
  exit 1
fi

echo "=== Stage 3: GitOps Operator + RBAC + Git Secrets ==="
oc apply -k 3-gitops-init

echo "Waiting for GitOps operator install plan..."
while ! oc get installplan -n openshift-gitops-operator -o json 2>/dev/null | grep -q '"name"'; do
  echo "  ...waiting for install plan"
  sleep 10
done
echo "Install plan found."

echo "Waiting for installplan-approver job to complete..."
oc wait --for=condition=complete job/installplan-approver -n openshift-gitops-operator --timeout=300s 2>/dev/null || true

echo "Waiting for GitOps operator pods..."
while [ "$(oc get pods -n openshift-gitops --no-headers 2>/dev/null | wc -l)" -lt 2 ]; do
  echo "  ...waiting for pods"
  sleep 10
done

echo "Waiting for ArgoCD server to be Running..."
while [ "$(oc get pods -l app.kubernetes.io/name=gitops-root-server -n openshift-gitops --no-headers -o jsonpath='{.items[0].status.phase}' 2>/dev/null)" != "Running" ]; do
  sleep 10
done
echo "ArgoCD server is running."

echo "=== Stage 4: ArgoCD Instance + Root Apps ==="
oc apply -k 4-openshift-gitops

echo "Waiting for ACM to be deployed via ArgoCD..."
echo "(Monitor progress: oc get multiclusterhub -n open-cluster-management)"
echo ""
echo "Bootstrap complete. ArgoCD will now reconcile:"
echo "  - ACM operator + MultiClusterHub (via mgt-cluster-acm Application)"
echo "  - ZTP GitOps stack (via root-applications Application)"
echo ""
echo "Next steps:"
echo "  1. Wait for MCH to reach 'Running' phase"
echo "  2. Verify ZTP GitOps ArgoCD instance in namespace ztp-gitops"
echo "  3. Sync the networklab SiteConfig to provision the spoke cluster"
