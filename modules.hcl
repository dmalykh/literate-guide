# ==============================================================================
# modules.hcl — module usage.
# Source: /reference/types/module/
# ==============================================================================

# Source: /reference/types/module/ — "Local Module" (invoking the module defined
# in ./modules/web-server, which follows the page's "Example Module Implementation").
module "web_stack" {
  source = "./modules/web-server"

  variables = {
    server_name = "module-web-server"
    port        = 8090
    image_tag   = "1.25"
  }
}

# Source: /reference/types/module/ — "Remote GitHub Module" pattern ("Use module
# outputs"): referencing a module output from the parent configuration.
# NOTE (docs finding): the docs document `module.<name>.output.<output_name>`,
# which fails validation ('does not expose output "output"') — the working form
# is `module.<name>.<output_name>`.
output "module_service_url" {
  value = module.web_stack.service_url
}
