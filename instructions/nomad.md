# Nomad

The sandbox started a single-node **nomad_cluster** ("Single Node Cluster") and deployed the docs' `web.nomad` jobspec through a **nomad_job** resource with a health check on the `web` job (Source: `/reference/sandbox/orchestration/nomad/`).

The job runs 3 instances of nginx behind Nomad's service discovery.

## Inspect the job

From the second terminal tab (the workstation), you can reach the Nomad API on the cluster:

```bash
curl -s http://server.dev.nomad-cluster.local.jmpd.in:4646/v1/jobs | head -40
```

If the API is not reachable from the workstation, use the lab logs to verify the `nomad_job` health check passed at provisioning time — the sandbox would not have become ready otherwise.
