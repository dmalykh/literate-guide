# Docs Example Gallery

A lab assembled **exclusively from the examples in the Instruqt documentation**
(docs.labs.instruqt.com). Its purpose is to verify that every documented example
is workable: each HCL block, script, and markdown component carries a `Source:`
comment naming the docs page (and example heading) it was taken from. If
something in this lab misbehaves, the comment points at the docs page that
needs fixing.

`instruqt lab format` and `instruqt lab validate` both pass on this repository.

## How to use

1. Push this directory to a GitHub repository and import it
   (Labs → Import lab), per `/getting-started/code/project-setup/`.
2. Start the lab and walk through the six chapters; each page tells you which
   examples it exercises and how to verify them.
3. Optionally run `instruqt lab test <team>/<lab>` for the automated pass
   (`/development/automated-testing/`).

### Toggles (org-dependent examples, off by default)

These documented examples need organization-side state, so they are gated with
the documented `disabled = !variable.X` pattern. Flip the defaults in
`variables.hcl` to enable them:

| Variable | Enables | Requires |
| -------- | ------- | -------- |
| `enable_cloud` | `aws_account`, `azure_subscription`, `google_project`, `cloud_credentials` | Cloud providers configured for the org. Also add a layout tab targeting `resource.cloud_credentials.all-credentials`. |
| `enable_team_secrets` | `secret` resources + consumer container | Team secrets `MY_API_KEY` and `DATABASE_PASSWORD` |
| `enable_private_registry` | `container_registry` | Real registry credentials |

## Coverage

| Docs area | Where in this lab |
| --------- | ----------------- |
| getting-started/code (tutorial lab) | `sandboxes.hcl` (network/webserver), `tabs.hcl` (terminal/service), `tasks.hcl` (edit_homepage), `layouts.hcl` (two_column), `instructions/customize_homepage.md`, `scripts/check_homepage.sh` |
| reference/content: lab, layout, page, task, quiz (+4 question types), note | `main.hcl`, `layouts.hcl` (all 4 layout examples + tab options), `content.hcl`, `tasks.hcl`, `quizzes.hcl`, notes in `tabs.hcl` |
| reference/sandbox/compute: container, sidecar, vm | `sandboxes.hcl` |
| reference/sandbox/networking: network, ingress | `sandboxes.hcl` |
| reference/sandbox/orchestration: k8s cluster/config, helm, nomad cluster/job | `sandboxes.hcl`, `k8s/webapp-deployment.yaml`, `jobs/web.nomad` |
| reference/sandbox/cloud: aws, azure, google | `cloud.hcl` (toggled) |
| reference/sandbox/ui: terminal, service, editor, external_website, virtual_browser, cloud_credentials | `tabs.hcl`, `cloud.hcl` |
| reference/sandbox/storage: copy, template | `sandboxes.hcl` |
| reference/sandbox/secrets: secret | `secrets.hcl` (toggled) |
| reference/sandbox/certificates: certificate_ca, certificate_leaf | `certificates.hcl` |
| reference/sandbox/utilities: exec (all 3 modes), http, build, image_cache, container_registry, terraform, random_creature/id/number/password/uuid | `sandboxes.hcl`, `scripts/exec/*`, `app/Dockerfile`, `terraform/main.tf` |
| reference/types: variable (incl. system variables), local (both block forms), output, module, resource (depends_on both forms, disabled, count, dynamic blocks) | `variables.hcl`, `functions.hcl`, `modules.hcl`, `modules/web-server/`, `experimental.hcl` |
| reference/functions: string, collection, numeric, encoding, datetime, filesystem, lab-environment | `functions.hcl`, `experimental.hcl`, page variables in `content.hcl` |
| ui-overview markdown components: runnable code blocks, code options, code groups, instruqt-task/quiz/completion/pdf | `instructions/*.md` |

Not exercised (no way to do so from a lab repo): `instruqt-slides` (needs a real
shared Google Slides deck), the UI-only insert-menu blocks (alerts, buttons,
Feedback) whose markdown syntax the docs never show, and the AI lab generation /
reporting / SSO / webhooks product areas.

## Docs findings

### Examples that fail `instruqt lab validate` as written

1. **/reference/content/lab/** — Full Syntax sets `theme = "modern_dark"`;
   validation only accepts `modern-dark` or `original` (the page's own field
   table has the right values; the example contradicts it).
2. **/reference/sandbox/ui/cloud-credentials/** — `google_project "gcp"` fails:
   google_project names must be at least 4 characters. Any 3-character label in
   the docs' examples breaks.
3. **/reference/sandbox/networking/ingress/** — every example targets
   `resource.kubernetes_cluster.*`, but `target.resource` rejects the
   `kubernetes_cluster` type; only `k8s_cluster` is accepted. Same for helm's
   `cluster` field. The cluster page itself teaches
   `resource "kubernetes_cluster"`, so the pages contradict each other.
4. **/reference/sandbox/networking/ingress/** — "Usage in Service Resources"
   defines a service without `port`, which is required.
5. **/reference/types/module/ (Example Module Implementation),
   /reference/types/variable/ (Resource Scaling), /reference/types/resource/** —
   set `container_name`, which is a computed field and rejected
   ("must not be set by user").
6. **/reference/types/output|local|resource|module/** — many examples read
   `resource.container.X.meta.name`; `meta` has no field `name`. The working
   computed field is `container_name` (or `meta.id` for IDs).
7. **/reference/types/module/** — documents module output references as
   `module.<name>.output.<output_name>`; the validator requires
   `module.<name>.<output_name>`.
8. **/reference/sandbox/ui/terminal/ ("Kubernetes Cluster Access") and
   /reference/types/output/ ("Module Resource Information")** — use
   `.kubeconfig_path`, a nonexistent field; the working attribute is
   `.kube_config.path` (as used on the cluster page).
9. **/reference/functions/ (overview)** — "Type Conversions" uses unnamed
   `local { port = ... }` blocks; a local requires a label and a `value` field.
   (The plural `locals { ... }` form used on the http page does parse.)

### Gaps and inconsistencies

10. **/configuration/lab-structure/, /configuration/content/,
    /configuration/sandbox/** are WIP stubs ("WIP" is their entire content).
11. **/reference/content/quiz/quiz/** — the `questions` field row lists
    `true_false_question`, `match_question`, `sequence_question`,
    `fill_in_the_blanks_question`, `drag_words_question`; all five exist in the
    validator but none has a reference page, and the page's "Supported Question
    Types" table claims only four types exist.
12. **Network references** — some pages chain `resource.network.X.meta.id`
    (container), others bare `resource.network.X` (nomad, helm, exec). Both
    validate; the docs never say both are OK or which is preferred.
13. **/reference/sandbox/compute/sidecar/** — Basic Syntax uses image
    `envoy:latest`, which is not a real Docker Hub image
    (`envoyproxy/envoy` is). Runtime-suspect.
14. **/reference/sandbox/utilities/exec/** — "Multi-Step Local Deployment" shows
    standalone `.sh` files containing HCL interpolation
    (`${resource.exec.download_app.output.DOWNLOAD_PATH}`); scripts are not
    templates, so this looks unworkable as written. Untested here.
15. **/reference/sandbox/compute/container/** — the "Basic Container"
    (bare `ubuntu:22.04`, no command) would exit immediately at runtime; every
    long-running ubuntu container in this lab needed `command = ["sleep",
    "infinity"]`.
16. **Terraform-style `var.` prefix** — the functions overview,
    image_cache, and container_registry pages write `var.registry_password`
    etc.; the platform's documented syntax is `variable.<name>`.
17. **/development/tasks/ vs /reference/sandbox/secrets/secret/** — the tasks
    page says validate rejects inline multi-line scripts, while the secret page
    shows an exec with an inline heredoc `script`. (The heredoc form was not
    needed in this lab; task scripts are all files.)

### Adaptations made (documented in-line)

- The copy-into-nginx volume is mounted writable (docs example is read-only) so
  the tutorial's `edit_homepage` task can modify the homepage.
- The postgres data volume uses `type = "volume"`; the docs example passes a
  bare name with the default bind type.
- `service_checks` validates marker files instead of real services so its
  checks fail before the user acts — `instruqt lab test` fails a run when a
  check passes on an untouched task.
- The VM's service uses port 80 (the startup script's nginx) instead of the
  docs' 8080 placeholder.
- Container/exec examples that referenced fictional images
  (`myapp:latest`, `worker:latest`) run real images instead.
