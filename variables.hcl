# ==============================================================================
# variables.hcl — input variables.
# Source: /reference/types/variable/
# ==============================================================================

# Source: /reference/types/variable/ — "String Variable"
variable "username" {
  default     = "admin"
  description = "Default username for system access"
}

# Source: /reference/types/variable/ — "Numeric Variable"
variable "cpu_resources" {
  default     = 2048
  description = "CPU resources allocation in millicores"
}

# Source: /reference/types/variable/ — "Boolean Variable" pattern, used as the
# feature toggles from "Feature Toggles" / resource "disabled" examples.
variable "enable_cloud" {
  default     = false
  description = "Enable the AWS/Azure/Google cloud sandbox examples (requires cloud providers configured for your organization)"
}

variable "enable_team_secrets" {
  default     = false
  description = "Enable the team secret examples (requires the team secrets MY_API_KEY and DATABASE_PASSWORD to exist)"
}

variable "enable_private_registry" {
  default     = false
  description = "Enable the private container registry example (requires real registry credentials)"
}

variable "registry_password" {
  default     = "replace-me"
  description = "Password for the private registry example"
}

# Source: /reference/types/variable/ — "List Variable"
variable "service_names" {
  default     = ["web", "api", "database"]
  description = "List of services to deploy"
}

# Source: /reference/types/variable/ — "Object Variable"
variable "database_config" {
  default = {
    username = "dbuser"
    password = "dbpass"
    database = "myapp"
    port     = 5432
  }
  description = "Database connection configuration"
}
