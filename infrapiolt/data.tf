###############################################################
#
# This file contains configuration for all data source queries
#
###############################################################

# Get the AMI for Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Get Public IP of the cloudshell server. This allows us to lock down SSH access
# into the environment from anyone other than yourself, by inserting its public
# IP to a security group ingress rule.
data "localos_public_ip" "cloudshell_ip" {}

# Get local folders (for storing ssh keys)
data "localos_folders" "folders" {}

# Get the default VPC details
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
  filter {
    name = "availability-zone"
    values = [
      "${var.aws_region}a",
      "${var.aws_region}b",
      "${var.aws_region}c"
    ]
  }
}