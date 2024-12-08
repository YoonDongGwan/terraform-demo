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
  public_subnet_cidr_block = {
    "ap-northeast-2a" = cidrsubnet(var.vpc_cidr_block, 8, 0),
    "ap-northeast-2b" = cidrsubnet(var.vpc_cidr_block, 8, 1)
  }
  private_subnet_cidr_block = {
    "ap-northeast-2a" = cidrsubnet(var.vpc_cidr_block, 8, 10),
    "ap-northeast-2b" = cidrsubnet(var.vpc_cidr_block, 8, 11),
    "ap-northeast-2c" = cidrsubnet(var.vpc_cidr_block, 8, 12)
  }
}

module "vpc" {
  source         = "./vpc"
  vpc_cidr_block = var.vpc_cidr_block
}


module "public_subnet" {
  source              = "./subnet"
  for_each            = local.public_subnet_cidr_block
  vpc_id              = module.vpc.vpc_id
  availability_zone   = each.key
  subnet_cidr_block   = each.value
  subnet_name         = "subnet-${each.key}-public"
  automatic_public_ip = true
}

module "private_subnet" {
  source              = "./subnet"
  for_each            = local.private_subnet_cidr_block
  vpc_id              = module.vpc.vpc_id
  availability_zone   = each.key
  subnet_cidr_block   = each.value
  subnet_name         = "subnet-${each.key}-private"
  automatic_public_ip = false
}

module "ec2_bastion" {
  source        = "./ec2"
  instance_type = "t2.micro"
  subnet_id     = module.public_subnet["ap-northeast-2a"].subnet_id
  public_key    = "SSH PUB KEY"
  instance_name = "ec2-ap-northeast-2a-bastion"
  vpc_id = module.vpc.vpc_id
  security_group_name = "sgr-ec2-ap-northeast-2a-bastion"
}