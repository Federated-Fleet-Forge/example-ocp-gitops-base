#!/bin/bash
set -euo pipefail
oc kustomize 4-openshift-gitops | oc delete -f - || true
oc kustomize 3-gitops-init | oc delete -f - || true
