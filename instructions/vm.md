# Virtual Machines

The sandbox includes a VM built from the VM reference examples (Source: `/reference/sandbox/compute/vm/`):

- image `ubuntu:24.04`, 2 CPUs, 2048 MB memory
- attached to the `main` network with the static IP `10.0.200.50`
- an extra 20G disk mounted at `/var/lib/app`
- a `startup_script` that installs nginx, curl and jq

Open the **VM Terminal** tab (this chapter uses the lab's default layout — switch tabs in the right column) and verify the startup script ran:

```bash,run
cat /etc/os-release | head -2
nginx -v
df -h /var/lib/app
```

The **VM Web** service tab serves the nginx instance the startup script installed (Source: `/reference/sandbox/compute/vm/` — "VM with Disk and Service Tab").
