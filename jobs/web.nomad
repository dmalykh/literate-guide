# Source: /reference/sandbox/orchestration/nomad/nomadjob/ — "Job with Service
# Configuration" (./jobs/web.nomad)
job "web" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    count = 3

    network {
      port "http" {
        to = 80
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:latest"
        ports = ["http"]
      }

      service {
        name = "web"
        port = "http"

        check {
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
