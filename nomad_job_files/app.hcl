job "test-app" {
  datacenters = ["dc1"]

  type = "service"

  # All tasks in this job must run on linux.
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "test-app" {
    count = 5

    update {
      max_parallel = 1
      min_healthy_time = "10s"
      healthy_deadline = "2m"
      canary = 1
    }

    task "test-app" {
      driver = "docker"

      config {
        image = "nicholasjackson/test-server:latest"

        args = [
          "-statsd_addr", "${NOMAD_IP_http}:8125",
          "-version", "v1.3",
          "-alloc_id","${NOMAD_ALLOC_ID}",
        ]
        
        port_map {
          http = 8080
        }
      }

      resources {
        cpu    = 100 # 100 MHz
        memory = 64 # 128MB

        network {
          mbits = 1

          port "http" {}
        }
      }

      service {
        port = "http"
        name = "test-app"
        tags = ["microservice", "urlprefix-/"]

        check {
          type     = "http"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/health"
        }
      }
  
    }
  }

}
