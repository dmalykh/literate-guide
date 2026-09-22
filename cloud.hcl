# ==============================================================================
# cloud.hcl — cloud sandbox accounts.
# Disabled by default: they require cloud providers to be configured for your
# organization. Toggle with variable.enable_cloud.
# ==============================================================================

# Source: /reference/sandbox/cloud/aws/account/ — "Basic Syntax"
resource "aws_account" "lab" {
  disabled = !variable.enable_cloud

  regions  = ["us-east-1"]
  services = ["ec2", "s3"]

  user "student" {
    managed_policies = [
      "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
    ]
  }
}

# Source: /reference/sandbox/cloud/azure/subscription/ — "Basic Syntax"
resource "azure_subscription" "lab" {
  disabled = !variable.enable_cloud

  regions  = ["westeurope"]
  services = ["Microsoft.Compute", "Microsoft.Storage"]

  user "student" {
    roles = ["Contributor"]
  }
}

# Source: /reference/sandbox/cloud/google/project/ — "Basic Syntax"
# NOTE (docs finding): google_project names must be at least 4 characters; the
# docs' own examples use 3-character names like "gcp" (cloud-credentials page),
# which fail validation. Renamed to "gcplab".
resource "google_project" "gcplab" {
  disabled = !variable.enable_cloud

  regions  = ["us-central1"]
  services = ["compute.googleapis.com", "storage.googleapis.com"]

  user "student" {
    roles = ["roles/editor"]
  }
}

# Source: /reference/sandbox/ui/cloud-credentials/ — "Full Syntax" (multi-cloud
# credentials tab resource; add it to a layout tab when enable_cloud is true).
resource "cloud_credentials" "all-credentials" {
  disabled = !variable.enable_cloud

  aws_account {
    target = resource.aws_account.lab
    users  = ["student"]
  }

  google_project {
    target = resource.google_project.gcplab
    users  = ["student"]
  }

  azure_subscription {
    target = resource.azure_subscription.lab
    users  = ["student"]
  }
}
