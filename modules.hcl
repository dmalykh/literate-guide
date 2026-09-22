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
# NOTE: the docs' `module.<name>.output.<output_name>` form is CORRECT — it is
# what the engine evaluates. CLI builds bundling mono older than #1235
# (2026-09-10) had an off-by-one validator bug that rejected this form and
# accepted `module.<name>.<output_name>` instead; update the CLI if this line
# fails validation locally.
output "module_service_url" {
  value = module.web_stack.output.service_url
}
