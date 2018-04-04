job "test-app" {
  datacenters = ["dc1"]

  type = "service"

  group "test-app" {
    count = 5
    
    task "test-app" {
      driver = "docker"

      config {
        image = "nicholasjackson/test-server:latest"

        args = [
          "-statsd_addr", "${NOMAD_IP_http}:8125",
          "-version", "v1.1",
          "-alloc_id","${NOMAD_ALLOC_ID}"
        ]
        
        port_map {
          http = 8080
        }
      }

      vault {
        policies = ["my-policy"]
      }     

      template {
        destination = "secrets/cert.pem"
        data = <<EOT
{{ with secret "pki/issue/my-role" "common_name=example.my-website.com" "ip_sans=127.0.0.1,{{ env "NOMAD_IP_http" }}" "ttl=24h"}}
{{ .Data.certificate }}{{ end }}
EOT
      }
      
      template {
        destination = "secrets/key.pem"
        data = <<EOT
{{ with secret "pki/issue/my-role" "common_name=example.my-website.com" "ip_sans=127.0.0.1,{{ env "NOMAD_IP_http" }}"}}" "ttl=24h"}}
{{ .Data.private_key }}{{ end }}
EOT
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
