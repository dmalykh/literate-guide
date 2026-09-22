# Source: /reference/types/module/ — "Example Module Implementation" (variables.hcl)
variable "server_name" {
  default     = "web-server"
  description = "Name of the web server"
}

variable "port" {
  default     = 80
  description = "Port for the web server"
}

variable "image_tag" {
  default     = "latest"
  description = "Docker image tag to use"
}
