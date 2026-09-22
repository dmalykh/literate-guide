# ==============================================================================
# experimental.hcl — documented constructs that need runtime verification.
# Each block is a documented example from the pages named in the Source comments.
# ==============================================================================

# Source: /reference/types/variable/ — "Resource Scaling" (count / count.index;
# image and command adapted so the containers actually run — the docs example's
# `container_name` field is rejected as computed, see modules/web-server/main.hcl).
resource "container" "worker" {
  count = 2

  image {
    name = "ubuntu:22.04"
  }

  command = ["sleep", "infinity"]

  environment = {
    WORKER_ID = tostring(count.index + 1)
  }
}

# Source: /reference/types/local/ — "Function-Based Computation"
local "service_names" {
  value = [for i in range(2) : format("service-%02d", i + 1)]
}

local "primary_service" {
  value = element(local.service_names, 0)
}

# Source: /reference/types/local/ — "List Manipulation" (dynamic "port" block;
# list inlined instead of mapping over an undeclared variable).
local "service_ports" {
  value = [8081, 8082]
}

resource "container" "proxy" {
  image {
    name = "nginx:latest"
  }

  command = ["sleep", "infinity"]

  dynamic "port" {
    for_each = local.service_ports
    content {
      local = tostring(port.value)
    }
  }
}

# Source: /reference/sandbox/utilities/http/ — "Error Handling Pattern"
# (uses the plural `locals { }` block form as written in that example).
locals {
  api_success = resource.http.api_check.status >= 200 && resource.http.api_check.status < 300
  api_error   = resource.http.api_check.status >= 400
}

output "api_result" {
  value = local.api_success ? "Success" : "Failed with status ${resource.http.api_check.status}"
}

# Source: /reference/types/resource/ — "Resource with Dependencies"
# (string form of depends_on).
resource "copy" "depends_string_form" {
  depends_on = ["resource.copy.app_files"]

  source      = "./files/html/index.html"
  destination = "./container-data/html-copy/index.html"
  permissions = "0644"
}

# Source: /reference/sandbox/utilities/exec/ — "Multi-Step Local Deployment"
# (bare reference form of depends_on).
resource "exec" "depends_ref_form" {
  depends_on = [resource.exec.local_setup]

  script = "scripts/exec/local_setup/script.sh"
}

# Source: /reference/functions/ (overview) — "Conditional Values" (coalesce) and
# "Using Functions in Resources" (formatdate + timestamp).
local "overview_functions" {
  value = {
    log_level      = upper(coalesce("", "info"))
    today          = formatdate("YYYY-MM-DD", timestamp())
    data_workspace = data("workspace")
    exists_hosts   = exists("/etc/hosts")
  }
}

output "overview_functions" {
  value = local.overview_functions
}

# Source: /reference/functions/filesystem/ — template_file
output "template_file_demo" {
  value = template_file("./modules/web-server/templates/nginx.conf.tpl", {
    server_name = "demo.local"
    listen_port = 8080
  })
}
