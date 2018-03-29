# Nomad Multi-Cloud Example
Simple example of running a federated nomad cluster in GCP and AWS

## Terraform
To create the cluster first set the environments variables required by the terraform providers

```bash
export AWS_ACCESS_KEY_ID="XXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="CXXXXXXXXXXX"
export AWS_DEFAULT_REGION="eu-west-1"
export TF_VAR_aws_region="eu-west-1"

# GCP
export GOOGLE_CLOUD_KEYFILE_JSON=$HOME/.gcp/nomad-multi-cloud.json
```

Run `terraform plan` check everything looks ok then run `terraform apply` to create the clusters and a VPN linking the two together.

```bash
$ terraform plan

$ terraform apply
```

### Federate the cluster
1. Obtain the external ip address of a server from AWS
1. Obtain the internal ip address of a server in GCP
1. SSH into the AWS instance and run the following commands:

```bash
$ consul join -wan <gcp internal ip>
$ nomad server-join <gcp internal ip>
```

