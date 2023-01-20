data "aws_availability_zones" "available" {
  state = "available"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "k8-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  #private_subnets = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
  #public_subnets  = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)

  enable_nat_gateway = true
  single_nat_gateway = true
  create_igw = true
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
