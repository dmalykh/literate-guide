# Source: /reference/types/module/ — "Example Module Implementation" (outputs.hcl)
# NOTE (docs finding): the docs example reads resource.container.web.meta.name,
# but `meta` has no field "name" — the computed container_name field is used
# here instead.
output "container_name" {
  value       = resource.container.web.container_name
  description = "Name of the web server container"
}

output "service_url" {
  value       = format("http://localhost:%d", variable.port)
  description = "URL to access the web server"
}
