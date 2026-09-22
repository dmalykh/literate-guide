# ==============================================================================
# secrets.hcl — team secrets.
# Disabled by default: they require the referenced secrets to exist in your
# team's settings. Toggle with variable.enable_team_secrets.
# ==============================================================================

# Source: /reference/sandbox/secrets/secret/ — "Basic Syntax" / "Usage in Other Resources"
resource "secret" "api_key" {
  disabled = !variable.enable_team_secrets

  reference = "MY_API_KEY"
}

# Source: /reference/sandbox/secrets/secret/ — "Injecting a Secret into a Container"
resource "secret" "db_password" {
  disabled = !variable.enable_team_secrets

  reference = "DATABASE_PASSWORD"
}

# Source: /reference/sandbox/secrets/secret/ — "Usage in Other Resources"
# (container consuming secret values through environment variables).
resource "container" "secret_demo" {
  disabled = !variable.enable_team_secrets

  image {
    name = "ubuntu:22.04"
  }

  command = ["sleep", "infinity"]

  environment = {
    API_KEY           = resource.secret.api_key.value
    DATABASE_PASSWORD = resource.secret.db_password.value
  }
}
