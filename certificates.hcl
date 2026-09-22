# ==============================================================================
# certificates.hcl — certificate authority and leaf certificates.
# ==============================================================================

# Source: /reference/sandbox/certificates/cert/certificateca/ — "Simple CA Certificate"
resource "certificate_ca" "root" {
  output = "./certs"
}

# Source: /reference/sandbox/certificates/cert/certificateleaf/ — "Simple Server Certificate"
resource "certificate_leaf" "server" {
  ca_key  = resource.certificate_ca.root.private_key.path
  ca_cert = resource.certificate_ca.root.certificate.path
  output  = "./server-certs"

  dns_names    = ["localhost"]
  ip_addresses = ["127.0.0.1"]
}

# Source: /reference/sandbox/certificates/cert/certificateleaf/ — "Client Certificate
# Authentication" (template consuming certificate attributes).
resource "template" "client_config" {
  source = <<-EOF
    client:
      certificate: ${resource.certificate_leaf.server.certificate.path}
      private_key: ${resource.certificate_leaf.server.private_key.path}
      ca_certificate: ${resource.certificate_ca.root.certificate.path}

    tls:
      verify_peer: true
      verify_host: true
  EOF

  destination = "./client-config.yaml"
}
