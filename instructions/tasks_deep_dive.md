# Hands-On Practice

This page embeds two tasks built from the task reference examples (Source: `/reference/content/task/`). Tasks on a page complete **in order** — the second shows a Locked badge until the first is done (Source: `/development/tasks/`).

## Task 1 — Simple File Creation

Create the configuration file in the workstation terminal:

```bash,run
echo "setting=value" > /etc/myapp.conf
```

<instruqt-task id="create_file"></instruqt-task>

## Task 2 — Parallel Validations

This task runs its three check scripts **in parallel** (`parallel_exec { check = true }`) and demonstrates setup, solve and cleanup scripts plus per-condition and per-script config overrides.

Create the three marker files:

<instruqt-code-group>
  <instruqt-code language="bash" title="One by one" run>
  touch /tmp/svc_a.done
  touch /tmp/svc_b.done
  touch /tmp/svc_c.done
  </instruqt-code>
  <instruqt-code language="bash" title="All at once" run>
  touch /tmp/svc_{a,b,c}.done
  </instruqt-code>
</instruqt-code-group>

<instruqt-task id="service_checks"></instruqt-task>

The code group above is the `<instruqt-code-group>` component from `/ui-overview/adding-content/markdown-editor/`.
