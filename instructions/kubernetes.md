# Kubernetes

This chapter uses the docs' **"Three Column Layout"** — the first terminal tab is the kubectl container with the cluster's kubeconfig mounted (Source: `/reference/sandbox/orchestration/k8s/cluster/` — "Terminal Access").

The sandbox started:

1. A single-node **kubernetes_cluster** ("Basic Single-Node Cluster").
2. A **kubernetes_config** that applied `k8s/webapp-deployment.yaml` — the docs' "Basic Deployment" (nginx, 2 replicas + ClusterIP service) — and waited for pods labeled `app=webapp`.
3. A **helm** release of the bitnami `nginx` chart ("Simple Chart from Repository").
4. An **ingress** exposing the `webapp` service on port 8080, surfaced as a service tab (Source: `/reference/sandbox/networking/ingress/`).

## Verify the deployments

In the kubectl terminal:

```bash,run
kubectl get nodes
```

```bash,run
kubectl get deploy,svc,pods
```

You should see the `webapp` deployment from `kubernetes_config` and the `nginx` release from helm.

## Verify the ingress

Ask the webapp service for its default page through the cluster service:

```bash,run
kubectl run curl-test --image=nginx:1.21 --rm -i --restart=Never -- curl -s http://webapp
```
