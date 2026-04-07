    env:
    - name: ARGOCD_CLUSTER_CONFIG_NAMESPACES
      #these are namespaces in which you install argocd, those namespaced instances can then render cluster scoped resources. 
      value: openshift-gitops,ztp-gitops