provider "nomad" {
  address = "http://localhost:5646"
  region  = "gcp"
}

resource "nomad_job" "application" {
  jobspec = "${file("../../nomad_job_files/binary.hcl")}"
}
