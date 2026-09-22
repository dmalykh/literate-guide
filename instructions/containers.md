# Containers, Storage & Utilities

This page's layout is the docs' **"Complex Layout with Rows"** example — instructions on the left, a terminal/editor row and a service row on the right.

The sandbox contains containers built from the container reference examples:

- **webserver** — nginx from the getting-started guide, its html directory seeded by a `copy` resource and mounted as a volume.
- **workstation** — the basic `ubuntu:22.04` container; an `exec` resource wrote `/etc/motd` and `/root/workspace/README.txt` into it at startup.
- **postgres** — the "Database Container with Volume" example; its password comes from a `random_password` resource, and an `exec` created a `users` table.
- **redis** — runs with a `redis.conf` rendered by the `template` resource ("Usage with Containers").
- **built_app** — runs the image produced by the `build` resource from `./app/Dockerfile`.
- **metrics** — an nginx-prometheus-exporter *sidecar* attached to the webserver.

## Inspect the results

Check what the exec setup script left behind:

```bash,run
cat /etc/motd
cat /root/workspace/README.txt
```

The **Editor** tab shows three workspaces — a local one (`files/html`), the webserver's `/etc/nginx/conf.d`, and this workstation's `/root` (Source: `/reference/sandbox/ui/editor/` — "Mixed Local and Remote").

## Certificates

A `certificate_ca` and `certificate_leaf` were generated at start (Source: `/reference/sandbox/certificates/`). The CA certificate was injected into this container's environment:

```bash,run
echo "$CA_CERTIFICATE" | head -3
```

## System variables

The platform injected session values into this container (Source: `/reference/types/variable/` — "System Variables"):

```bash,run
echo "$CALLBACK_URL"
```
