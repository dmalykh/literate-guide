# Source: /reference/types/module/ — "Example Module Implementation" (main.hcl)
# NOTE (docs finding): the docs example sets `container_name`, which validation
# rejects ("computed field must not be set by user").
resource "container" "web" {
  image {
    name = "nginx:${variable.image_tag}"
  }

  port {
    local = tostring(variable.port)
  }
}

resource "template" "config" {
  source      = "templates/nginx.conf.tpl"
  destination = "./nginx.conf"

  vars = {
    server_name = variable.server_name
    listen_port = variable.port
  }
}
