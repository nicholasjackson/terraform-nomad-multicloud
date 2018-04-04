# Nomad Multi-Cloud Example
Simple example of running a federated nomad cluster in GCP and AWS

## Creating a multi-cloud cluster with terraform
To create the cluster first set the environments variables required by the terraform providers

```bash
export AWS_ACCESS_KEY_ID="XXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="CXXXXXXXXXXX"
export AWS_DEFAULT_REGION="eu-west-1"
export TF_VAR_aws_region="eu-west-1"

# GCP
export GOOGLE_CLOUD_KEYFILE_JSON=$HOME/.gcp/nomad-multi-cloud.json
```

Change directory to the `terraform/cluster` folder in the root of this repo

Run `terraform plan` check everything looks ok then run `terraform apply` to create the clusters and a VPN linking the two together.

```bash
$ terraform plan

$ terraform apply
```
## Running Vault
Currently the config will install and configure Vault on AWS however it does not automatically setup Nomad, Vault is also currently not secured via TLS certificates.  This is provided for demonstration purposes only.

## Connecting to the cluster
1. Obtain the external and internal ip addresses of a server from AWS
1. Obtain the internal ip address of a server in GCP

The cluster by default does not allow any inbound traffic other than SSH on port 22, to use the nomad cli with the server, either SSH directly to it or create an SSH tunnel between your local computer and one of the server nodes.

### Creating an SSH tunnel
The following example will setup an SSH tunnel from your local machine which will allow the use of the `nomad` and `consul` cli tools locally.

```bash
$ ssh -f ubuntu@[server external ip] -L 4645:[server internal ip]:4646 -N // nomad
$ ssh -f ubuntu@[server external ip] -L 9500:[server internal ip]:8500 -N // consul

$ export NOMAD_ADDR=http://localhost:4645
$ export CONSUL_HTTP_ADDR=http://localhost:9500
```

### Federate the cluster
1. SSH into the AWS instance or use your ssh tunnel and run the following commands:

```bash
$ consul join -wan <gcp internal ip>
$ nomad server-join <gcp internal ip>
```

The federation process will work from either AWS or GCP however only needs to be performed once.
