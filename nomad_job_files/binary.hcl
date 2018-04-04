job "test-app-binary" {
  datacenters = ["dc1"]

  type = "service"

  group "test-app" {
    count = 2
    
    task "test-app" {
      driver = "exec"
      
      artifact {
        source      = "https://github.com/nicholasjackson/terraform-nomad-multicloud/releases/download/v0.1/test-server"
        destination = "local"
      }

      config {
        command = "local/test-server"

        args = [
          "-statsd_addr", "${NOMAD_IP_http}:8125",
          "-port", "${NOMAD_PORT_http}",
          "-version", "v1.1",
          "-alloc_id","${NOMAD_ALLOC_ID}"
        ]
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
