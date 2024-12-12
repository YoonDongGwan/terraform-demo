terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  public_subnet_cidr_blocks = {
    "ap-northeast-2a" = cidrsubnet(var.vpc_cidr_block, 8, 0),
    "ap-northeast-2b" = cidrsubnet(var.vpc_cidr_block, 8, 1)
  }
  private_subnet_cidr_blocks = {
    "ap-northeast-2a" = cidrsubnet(var.vpc_cidr_block, 8, 10),
    "ap-northeast-2b" = cidrsubnet(var.vpc_cidr_block, 8, 11),
    "ap-northeast-2c" = cidrsubnet(var.vpc_cidr_block, 8, 12)
  }
}

module "vpc" {
  source         = "./vpc"
  vpc_cidr_block = var.vpc_cidr_block
  region         = var.region
}


module "public_subnet" {
  source              = "./subnet"
  subnet_cidr_blocks  = local.public_subnet_cidr_blocks
  vpc_id              = module.vpc.vpc_id
  automatic_public_ip = true
  vpc_cidr_block      = var.vpc_cidr_block
  access_modifier     = "public"
  region              = var.region
}

module "private_subnet" {
  source              = "./subnet"
  subnet_cidr_blocks  = local.private_subnet_cidr_blocks
  vpc_id              = module.vpc.vpc_id
  automatic_public_ip = false
  vpc_cidr_block      = var.vpc_cidr_block
  access_modifier     = "private"
  nat_subnet_id       = module.public_subnet.subnet_id[0]
  region              = var.region
}

# module "ec2_bastion" {
#   source        = "./ec2"
#   instance_type = "t2.micro"
#   subnet_id     = module.public_subnet.subnet_id[0]
#   public_key    = var.public_key
#   instance_name = "ec2-${element(local.availability_zones,0)}-bastion"
#   vpc_id = module.vpc.vpc_id
#   security_group_name = "sgr-ec2-${var.region}-bastion"
# }

# module "eks_cluster" {
#   source = "./eks"
#   cluster_name = "eks-cluster-ap-northeast-2"
#   private_subnet_a = module.private_subnet["ap-northeast-2a"].subnet_id
#   private_subnet_b = module.private_subnet["ap-northeast-2b"].subnet_id
#   bastion_ip = module.ec2_bastion.bastion_ip
#   node_group_name = "eks-node-group-t3-medium"
#   node_group_instance_type = "t3.medium"
#   scaling_desired_size = 3
#   scaling_max_size = 2
#   scaling_min_size = 2
#   vpc_id = module.vpc.vpc_id
# }