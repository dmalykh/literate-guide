# Dynamic Values & Functions

The lab's HCL exercises every documented function category (Source: `/reference/functions/`). The values below were computed **at build time by documented functions** and injected into this page through page variables (Source: `/reference/content/page/` — "Variable Substitution"):

| Function | Documented example | Result |
| -------- | ------------------ | ------ |
| `upper` | `upper("hello world")` | {{upper_demo}} |
| `join` | `join(", ", ["apple", "banana", "cherry"])` | {{join_demo}} |
| `format` | `format("%s-%02d", "web", 1)` | {{format_demo}} |
| `max` | `max(1, 5, 3)` | {{max_demo}} |
| `base64_encode` | `base64_encode("instruqt")` | {{encode_demo}} |

The full showcase — string, collection, numeric, encoding, datetime, filesystem, and lab-environment functions — lives in `functions.hcl` as `local` blocks surfaced through `output` resources. {{session_note}}.

Other dynamic values defined in this lab:

- **Variables** — string, numeric, boolean, list and object variables (`variables.hcl`)
- **Locals** — computed values, including the docs' connection-string example
- **Outputs** — resource attributes (container names, random values, certificate paths, HTTP responses, exec output variables, terraform outputs, module outputs)
- **Secrets** — team secret references (disabled by default; see `secrets.hcl`)
- **System variables** — `instruqt_`-prefixed values injected by the platform
