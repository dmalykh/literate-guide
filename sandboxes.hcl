# ==============================================================================
# sandboxes.hcl — sandbox infrastructure.
# Every block is a documented example; the Source comment names the docs page.
# ==============================================================================

# ------------------------------------------------------------------------------
# Networks
# ------------------------------------------------------------------------------

# Source: /getting-started/code/infrastructure/ — "Create the Infrastructure Configuration"
# Network - Foundation for all container communication
resource "network" "main" {
  subnet = "10.0.200.0/24"
}

# Source: /reference/sandbox/networking/network/ — "Basic Network"
resource "network" "backend" {
  subnet = "10.0.1.0/24"
}

# Source: /reference/sandbox/networking/network/ — "Network with IPv6"
resource "network" "frontend" {
  subnet      = "10.0.2.0/24"
  enable_ipv6 = true
}

# ------------------------------------------------------------------------------
# Containers
# ------------------------------------------------------------------------------

# Source: /getting-started/code/infrastructure/ — "Add the Web Server Container",
# extended with the copy-into-volume pattern from /reference/sandbox/storage/copy/
# — "Using with Container Volumes" (mounted writable so the tutorial task
# "edit_homepage" can modify the homepage).
resource "container" "webserver" {
  image {
    name = "nginx:1.25"
  }

  port {
    local = 80 # Port inside the container
  }

  # Resource chaining - connect to network
  network {
    id = resource.network.main.meta.id
  }

  volume {
    source      = resource.copy.app_files.destination
    destination = "/usr/share/nginx/html"
    type        = "bind"
  }
}

# Source: /reference/sandbox/compute/container/ — "Basic Container" (ubuntu:22.04),
# kept alive with a command the way /reference/sandbox/orchestration/k8s/cluster/
# — "Terminal Access" keeps its kubectl container alive. Environment shows the
# system variables from /reference/types/variable/ — "System Variables".
resource "container" "workstation" {
  image {
    name = "ubuntu:22.04"
  }

  command = ["sleep", "infinity"]

  environment = {
    # Source: /reference/types/variable/ — "System Variables"
    CALLBACK_URL = "https://service-workshop-${variable.instruqt_session_id}.${variable.instruqt_sandbox_domain}"
    # Source: /reference/functions/lab-environment/ — docker_host()
    DOCKER_HOST = docker_host()
    # Source: /reference/sandbox/certificates/cert/certificateca/ — "Certificate Contents Usage"
    CA_CERTIFICATE = resource.certificate_ca.root.certificate.contents
  }

  network {
    id = resource.network.main.meta.id
  }

  # Source: /reference/sandbox/compute/container/ — "Full Syntax" (port_range)
  port_range {
    range       = "3000-3010"
    enable_host = true
    protocol    = "tcp"
  }

  # Source: /reference/sandbox/compute/container/ — "Full Syntax" (resources)
  resources {
    cpu    = 1000 # 1 CPU = 1000
    memory = 512  # MB
  }
}

# Source: /reference/sandbox/compute/container/ — "Database Container with Volume",
# with the password coming from /reference/sandbox/utilities/random/randompassword/
# — "Database Password with Requirements".
resource "container" "postgres" {
  image {
    name = "postgres:15"
  }

  environment = {
    POSTGRES_PASSWORD = resource.random_password.db_password.value
    POSTGRES_DB       = "myapp"
  }

  volume {
    source      = "postgres-data"
    destination = "/var/lib/postgresql/data"
    type        = "volume"
  }

  port {
    local = 5432
  }

  network {
    id = resource.network.backend.meta.id
  }
}

# Source: /reference/sandbox/storage/template/ — "Usage with Containers"
# (redis.conf template rendered below, mounted into the container).
resource "container" "redis" {
  image {
    name = "redis:6-alpine"
  }

  network {
    id = resource.network.backend.meta.id
  }

  volume {
    source      = resource.template.redis_config.destination
    destination = "/usr/local/etc/redis/redis.conf"
    type        = "bind"
  }

  command = ["redis-server", "/usr/local/etc/redis/redis.conf"]
}

# Source: /reference/sandbox/orchestration/k8s/cluster/ — "Terminal Access"
# (kubectl container with the cluster's kubeconfig mounted).
resource "container" "kubectl" {
  image {
    name = "bitnami/kubectl:latest"
  }

  network {
    id = resource.network.main.meta.id
  }

  volume {
    source      = resource.k8s_cluster.k8s.kube_config.path
    destination = "/root/.kube/config"
    type        = "bind"
  }

  command = ["sleep", "infinity"]
}

# Source: /reference/sandbox/utilities/build/ — "Build and reference an image"
resource "container" "built_app" {
  image {
    name = resource.build.app.image
  }

  network {
    id = resource.network.main.meta.id
  }
}

# ------------------------------------------------------------------------------
# Sidecar
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/compute/sidecar/ — "Monitoring Sidecar with Resource
# Constraints" (target adapted to this lab's webserver container).
resource "sidecar" "metrics" {
  target = resource.container.webserver

  image {
    name = "nginx/nginx-prometheus-exporter:latest"
  }

  command = [
    "-nginx.scrape-uri=http://localhost:8080/metrics"
  ]

  resources {
    cpu    = 100 # 0.1 CPU
    memory = 128 # 128MB
  }

  health_check {
    timeout = "30s"

    tcp {
      address = "localhost:9113"
    }
  }
}

# ------------------------------------------------------------------------------
# Virtual machine
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/compute/vm/ — "VM with Network and Terminal Access"
# plus the disk block from "VM with Disk and Service Tab".
resource "vm" "devbox" {
  image {
    name = "ubuntu:24.04"
  }

  resources {
    cpu    = 2
    memory = 2048
  }

  network {
    id         = resource.network.main.meta.id
    ip_address = "10.0.200.50"
  }

  disk {
    destination = "/var/lib/app"
    size        = "20G"
  }

  port {
    local = 80
  }

  startup_script = <<-EOF
    #!/bin/sh
    apt-get update
    apt-get install -y nginx curl jq
  EOF
}

# ------------------------------------------------------------------------------
# Kubernetes
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/orchestration/k8s/cluster/ — "Basic Single-Node Cluster"
# NOTE (docs finding): the cluster page declares `resource "kubernetes_cluster"`,
# but helm's `cluster` field and ingress's `target.resource` reject references of
# type "kubernetes_cluster" — they require "k8s_cluster". The ingress page's own
# examples (all `resource.kubernetes_cluster...`) fail validation as written.
resource "k8s_cluster" "k8s" {
  network {
    id = resource.network.main.meta.id
  }
}

# Source: /reference/sandbox/orchestration/k8s/config/ — "Simple Application Deployment"
resource "kubernetes_config" "webapp" {
  cluster          = resource.k8s_cluster.k8s
  paths            = ["./k8s/webapp-deployment.yaml"]
  wait_until_ready = true

  health_check {
    timeout = "60s"
    pods    = ["app=webapp"]
  }
}

# Source: /reference/sandbox/orchestration/helm/helm/ — "Simple Chart from Repository"
resource "helm" "nginx" {
  cluster = resource.k8s_cluster.k8s
  chart   = "nginx"

  repository {
    name = "bitnami"
    url  = "https://charts.bitnami.com/bitnami"
  }

  values_string = {
    "service.type" = "ClusterIP"
    "replicaCount" = "2"
  }
}

# Source: /reference/sandbox/networking/ingress/ — "Expose Web Application"
# (service/namespace adapted to the webapp deployed by kubernetes_config above).
resource "ingress" "webapp" {
  port = 8080

  target {
    resource = resource.k8s_cluster.k8s
    port     = 80

    config = {
      service   = "webapp"
      namespace = "default"
    }
  }
}

# ------------------------------------------------------------------------------
# Nomad
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/orchestration/nomad/nomadcluster/ — "Single Node Cluster"
# (network reference written exactly as the docs example: no .meta.id).
resource "nomad_cluster" "dev" {
  network {
    id = resource.network.main
  }
}

# Source: /reference/sandbox/orchestration/nomad/nomadjob/ — "Simple Job Deployment"
# with the health_check from "Multiple Jobs with Health Check".
resource "nomad_job" "web" {
  cluster = resource.nomad_cluster.dev
  paths   = ["./jobs/web.nomad"]

  health_check {
    timeout = "60s"
    jobs    = ["web"]
  }
}

# ------------------------------------------------------------------------------
# Utilities: exec
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/compute/container/ — "Running Scripts"
# (exec targeting an existing container).
resource "exec" "setup" {
  target = resource.container.workstation
  script = "scripts/exec/setup/script.sh"
}

# Source: /reference/sandbox/utilities/exec/ — "Local Script Execution (Local Mode)"
# and "Output Variables".
resource "exec" "local_setup" {
  script = "scripts/exec/local_setup/script.sh"

  environment = {
    DEBIAN_FRONTEND = "noninteractive"
  }

  timeout = "600s"
}

# Source: /reference/sandbox/utilities/exec/ — "Script in Existing Container
# (Remote Mode - Existing Container)".
resource "exec" "init_database" {
  target = resource.container.postgres

  script  = "scripts/exec/init_database/script.sh"
  timeout = "120s"

  environment = {
    PGPASSWORD = resource.random_password.db_password.value
  }
}

# Source: /reference/sandbox/utilities/exec/ — "Container Network Setup
# (Remote Mode - New Container)".
resource "exec" "network_setup" {
  image {
    name = "alpine:latest"
  }

  network {
    id         = resource.network.backend
    ip_address = "10.0.1.10"
    aliases    = ["setup-container"]
  }

  script = "scripts/exec/network_setup/script.sh"
}

# ------------------------------------------------------------------------------
# Utilities: http
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/utilities/http/ — "Simple GET Request"
resource "http" "api_check" {
  method = "GET"
  url    = "https://httpbin.org/status/200"
}

# Source: /reference/sandbox/utilities/http/ — "POST with JSON Payload"
resource "http" "create_user" {
  method = "POST"
  url    = "https://jsonplaceholder.typicode.com/users"

  headers = {
    "Content-Type" = "application/json"
  }

  payload = jsonencode({
    name     = "John Doe"
    email    = "john@example.com"
    username = "johndoe"
  })
}

# ------------------------------------------------------------------------------
# Utilities: randomness
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/utilities/random/randomcreature/ — "Simple Creature Name"
resource "random_creature" "lab_id" {}

# Source: /reference/sandbox/utilities/random/randomid/ — "Simple Random ID"
resource "random_id" "session" {
  byte_length = 8
}

# Source: /reference/sandbox/utilities/random/randomnumber/ — "Random Port Number"
resource "random_number" "port" {
  minimum = 10000
  maximum = 20000
}

# Source: /reference/sandbox/utilities/random/randompassword/ — "Database Password
# with Requirements".
resource "random_password" "db_password" {
  length = 24

  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}

# Source: /reference/sandbox/utilities/random/randomuuid/ — "Simple UUID Generation"
resource "random_uuid" "session_id" {}

# ------------------------------------------------------------------------------
# Utilities: build & caches
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/utilities/build/ — "Build and reference an image"
resource "build" "app" {
  container {
    context = "./app"
  }
}

# Source: /reference/sandbox/utilities/cache/imagecache/ — "Simple Cache with Network"
resource "image_cache" "main" {
  network {
    id = resource.network.main.meta.id
  }
}

# Source: /reference/sandbox/utilities/cache/registry/ — "Simple Private Registry".
# Disabled by default: needs real registry credentials configured for your team.
# Toggle with variable.enable_private_registry.
resource "container_registry" "dockerhub" {
  disabled = !variable.enable_private_registry

  hostname = "registry.hub.docker.com"

  auth {
    username = "mydockerhubuser"
    password = variable.registry_password
  }
}

# ------------------------------------------------------------------------------
# Utilities: terraform
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/utilities/terraform/ — "Basic Syntax" with variables
# from "Full Syntax"; ./terraform contains a provider-less configuration.
resource "terraform" "example" {
  source = "./terraform"

  variables = {
    instance_count = 2
    vpc_cidr       = "10.0.0.0/16"
  }
}

# ------------------------------------------------------------------------------
# Storage: copy & template
# ------------------------------------------------------------------------------

# Source: /reference/sandbox/storage/copy/ — "Using with Container Volumes"
resource "copy" "app_files" {
  source      = "./files/html/"
  destination = "./container-data/html/"
  permissions = "0644"
}

# Source: /reference/sandbox/storage/copy/ — "Copy Directory with Specific Permissions"
resource "copy" "scripts" {
  source      = "./scripts/"
  destination = "./app/bin/"
  permissions = "0755"
}

# Source: /reference/sandbox/storage/template/ — "Usage with Containers"
resource "template" "redis_config" {
  source = <<-EOF
    port {{port}}
    bind {{bind_address}}
    save {{save_interval}} {{save_changes}}
    appendonly {{appendonly}}
    appendfsync {{appendfsync}}
    {{#if password}}
    requirepass {{password}}
    {{/if}}
  EOF

  destination = "./redis/redis.conf"

  variables = {
    port          = "6379"
    bind_address  = "0.0.0.0"
    save_interval = "900"
    save_changes  = "1"
    appendonly    = "yes"
    appendfsync   = "everysec"
    password      = "redis_password"
  }
}

# Source: /reference/sandbox/utilities/random/randomcreature/ — "Lab Instance
# Identification".
resource "template" "welcome_message" {
  source = <<-EOF
    Welcome to your lab instance: ${resource.random_creature.lab_id.value}

    You can refer to this instance as "${resource.random_creature.lab_id.value}" throughout the lab.

    Your unique lab environment is ready to use!
  EOF

  destination = "./welcome.txt"
}
