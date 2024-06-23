terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
resource "aws_vpc" "platform_api_vpc" {
 cidr_block           = var.vpc_cidr
 enable_dns_hostnames = true
 tags = {
   name = var.vpc_name
 }
}
resource "aws_subnet" "BeeQuantAI_subnets" {
  count = length(var.subnet_cidr_blocks)

  vpc_id     = aws_vpc.platform_api_vpc.id
  cidr_block = element(var.subnet_cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = element(var.subnet_names, count.index)
  }
}
resource "aws_nat_gateway" "BeeQuantAI_nat"{
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.BeeQuantAI_subnets[0].id

  tags = {
    Name = var.BeeQuantAI_nat_name
  }

  depends_on = [aws_internet_gateway.igw]
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.platform_api_vpc.id

  tags = {
    Name = var.igw_name
  }
}
resource "aws_eip" "eip_nat" {
#   count    = 1
  domain   = "vpc"
}
resource "aws_ecr_repository" "backend" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# module "rds" {
#   source = "./rds-module"
#   db_identifier = var.db_identifier
#   db_username = var.db_username
#   db_password = var.db_password
#   db_name = var.db_name
#   # db_parameter_group_name = var.db_parameter_group_name
#   availability_zones = var.availability_zones
#   subnet_cidr_blocks = var.subnet_cidr_blocks
#   subnet_names = var.subnet_names
#   kms_key_arn = var.kms_key_arn
#   db_sg_id = aws_security_group.db_sg.id
#   BeeQuantAI_subnets_id = [aws_subnet.BeeQuantAI_subnets[4].id, aws_subnet.BeeQuantAI_subnets[3].id]
# }
module "eks" {
    source = "./eks-module"
#   param  = value
    # version = "20.8.3"
    cluster_name = var.BeeQuantAI_ekscluster_name
    # cluster_version = "1.30"
    # subnet_ids = [aws_subnet.BeeQuantAI_subnets[4].id, aws_subnet.BeeQuantAI_subnets[3].id]
    # vpc_id = aws_vpc.platform_api_vpc.id
    clusterServiceRoleName = var.BeeQuantAI_ekscluster_service_role_name
    nodegroupServiceRoleName = var.BeeQuantAI_eksnodegroup_service_role_name
    BeeQuantAI_subnets_id = [aws_subnet.BeeQuantAI_subnets[2].id, aws_subnet.BeeQuantAI_subnets[3].id]
    BeeQuantAI_vpc_id = aws_vpc.platform_api_vpc.id
    node_group_name = var.BeeQuantAI_eksnodegroup_name
    node_group_desired_size = 1
    node_group_max_size = 3
    node_group_min_size = 1
    node_group_instance_type = ["t3a.large"]
}