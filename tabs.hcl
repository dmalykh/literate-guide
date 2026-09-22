# ==============================================================================
# tabs.hcl — UI resources targeted by layout tabs.
# ==============================================================================

# ------------------------------------------------------------------------------
# Terminals
# ------------------------------------------------------------------------------

# Source: /getting-started/code/infrastructure/ — "Create User Interface Elements"
# Terminal tab - provides command-line access
resource "terminal" "shell" {
  target = resource.container.webserver
  shell  = "/bin/bash"
}

# Source: /reference/sandbox/ui/terminal/ — "Full Syntax" (user/group/working
# directory on a container terminal).
resource "terminal" "workstation" {
  target            = resource.container.workstation
  shell             = "/bin/bash"
  user              = "root"
  group             = "root"
  working_directory = "/root"
}

# Source: /reference/sandbox/ui/terminal/ — "Terminal Targeting a VM"
resource "terminal" "vm_shell" {
  target = resource.vm.devbox
  shell  = "/bin/bash"
}

# Source: /reference/sandbox/orchestration/k8s/cluster/ — "Terminal Access"
resource "terminal" "k8s_terminal" {
  target            = resource.container.kubectl
  working_directory = "/root"
}

# Source: /reference/sandbox/ui/terminal/ — "Terminal for Database CLI"
# (database name adapted to the postgres container's POSTGRES_DB).
resource "terminal" "postgres_cli" {
  target  = resource.container.postgres
  user    = "postgres"
  group   = "postgres"
  command = ["psql", "-d", "myapp"]
}

# ------------------------------------------------------------------------------
# Services
# ------------------------------------------------------------------------------

# Source: /getting-started/code/infrastructure/ — "Create User Interface Elements"
# Service tab - exposes the nginx web server to users
resource "service" "webserver" {
  target = resource.container.webserver
  port   = 80
  scheme = "http"
}

# Source: /reference/sandbox/compute/vm/ — "VM with Disk and Service Tab"
resource "service" "vm_web" {
  target = resource.vm.devbox
  port   = 80
}

# Source: /reference/sandbox/networking/ingress/ — "Usage in Service Resources"
# NOTE (docs finding): the docs example omits `port`, but service requires it.
resource "service" "k8s_webapp" {
  target = resource.ingress.webapp
  port   = 8080
}

# ------------------------------------------------------------------------------
# Editor
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/ui/editor/ — "Mixed Local and Remote"
# (a local workspace plus container workspaces).
resource "editor" "config_editor" {
  workspace "local_assets" {
    directory = "files/html"
  }

  workspace "nginx_config" {
    target    = resource.container.webserver
    directory = "/etc/nginx/conf.d"
  }

  workspace "workstation_home" {
    target    = resource.container.workstation
    directory = "/root"
  }
}

# ------------------------------------------------------------------------------
# Notes
# ------------------------------------------------------------------------------

# Source: /reference/content/note/ — "Command Reference"
resource "note" "command_cheatsheet" {
  file = "notes/docker-commands.md"

  variables = {
    registry_url = "registry.company.com"
    namespace    = "production"
  }
}

# Source: /reference/content/note/ — "Reference Documentation"
resource "note" "api_reference" {
  file = "notes/api-documentation.md"

  variables = {
    base_url = "https://api.myservice.com"
    version  = "v2"
  }
}

# ------------------------------------------------------------------------------
# External website & virtual browser
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/ui/externalwebsite/ — "Documentation Reference"
resource "external_website" "kubernetes_docs" {
  url = "https://kubernetes.io/docs/"
}

# Source: /reference/sandbox/ui/virtualbrowser/ — "Basic Syntax"
resource "virtual_browser" "docs" {
  url = "https://example.com"
}
