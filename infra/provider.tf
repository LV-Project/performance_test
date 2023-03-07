terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.54.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
  key_name         = "leo_master"
  ssh_user         = "ubuntu"
  private_key_path = "/home/lv-project/personalProjects/PTCI/infra/leo_master.pem"
}
