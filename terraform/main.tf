# Provider-less Terraform configuration used by resource "terraform" "example"
# (Source: /reference/sandbox/utilities/terraform/). It only echoes its inputs
# back as outputs so the run needs no cloud credentials.

variable "instance_count" {
  type    = number
  default = 1
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

output "instance_count_out" {
  value = var.instance_count
}

output "vpc_cidr_out" {
  value = var.vpc_cidr
}
