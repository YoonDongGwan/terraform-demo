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
  nat_subnet_id       = module.public_subnet.subnet_id[keys(local.public_subnet_cidr_blocks)[0]]
  region              = var.region
}

module "ec2_bastion" {
  source               = "./ec2"
  instance_type        = "t2.micro"
  subnet_id            = module.public_subnet.subnet_id[keys(local.public_subnet_cidr_blocks)[0]]
  public_key           = var.public_key
  vpc_id               = module.vpc.vpc_id
  instance_name_suffix = "bastion"
}

module "eks_cluster" {
  source                   = "./eks"
  cluster_name             = "eks-cluster-ap-northeast-2"
  subnet_list              = values(module.private_subnet.subnet_id)
  bastion_ip               = module.ec2_bastion.bastion_private_ip
  node_group_name          = "eks-node-group-t3-medium"
  node_group_instance_type = "t3.medium"
  scaling_desired_size     = 2
  scaling_max_size         = 3
  scaling_min_size         = 2
  vpc_id                   = module.vpc.vpc_id
  region                   = var.region
  endpoint_private_access  = true
  endpoint_public_access   = false
}

module "rds_cluster" {
  source                = "./rds"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = [module.private_subnet.subnet_id["ap-northeast-2b"], module.private_subnet.subnet_id["ap-northeast-2c"]]
  availability_zones    = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.11.2"
  master_password       = "dgyoon1!"
  master_username       = "dgyoon"
  eks_subnet_cidr_block = values(module.private_subnet.cidr_block)
}