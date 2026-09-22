# Welcome to {{lab_name}}

This lab was assembled **exclusively from the examples in the Instruqt documentation**. Every sandbox resource, task, quiz, layout, and function you see here is a documented example — the HCL files name the docs page each block came from in a `Source:` comment.

## Variable substitution

This page demonstrates page variables (Source: `/reference/content/page/`):

- Version: {{version}}
- API URL: {{api_url}}

## What's in the sandbox

| Area | Resources |
| ---- | --------- |
| Networking | 3 networks (one with IPv6) |
| Compute | nginx, ubuntu workstation, postgres, redis, kubectl, built image, sidecar, a VM |
| Orchestration | Kubernetes cluster (+config, +helm, +ingress), Nomad cluster (+job) |
| Utilities | exec, http, copy, template, build, image cache, terraform, all five randomizers |
| Security | certificate CA + leaf, (optional) team secrets |
| Cloud | (optional) AWS account, Azure subscription, Google project + credentials tab |

## Try the terminal

Run this in the Terminal tab — the code block below is a *runnable* block (Source: `/ui-overview/adding-content/markdown-editor/`):

```bash,run
echo "Hello from the terminal"
```

A block with more options — line numbers and word wrap:

```javascript,run,line-numbers,wrap
const message = "This is a long line that wraps instead of scrolling horizontally.";
console.log(message);
```

And one without a copy button:

```bash,nocopy
echo "you have to type this one yourself"
```

Continue to the next page to start the hands-on work.
