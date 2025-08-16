
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "tracemypods"
}



module "eks" {
  source                  = "../../modules/terraform-aws-eks-m"
  cluster_name            = var.cluster_name
  cluster_version         = "1.33"
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  public_subnet_ids       = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  node_group_instance_types = ["t3.medium", "t3.large"]
  node_group_min_size       = 1
  node_group_max_size       = 3
  node_group_desired_size   = 2

  tags = {
    Owner       = "ahmadrazalab"
    Environment = "dev"
    Project     = "tracemypods"
  }
}



data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../vpc/terraform.tfstate"
  }
}


locals {
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

locals {
  public_subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}