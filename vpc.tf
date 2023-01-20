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
/*
resource "aws_subnet" "public_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.20.${10+count.index}.0/24" #cidr_block = cidrsubnet(var.vpc_cidr,8,length(data.aws_availability_zones.available.names[count.index]))
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags {
    Name = "PublicSubnet"
  }
}
resource "aws_subnet" "private_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.20.${20+count.index}.0/24" #cidr_block = cidrsubnet(var.vpc_cidr,8,length(data.aws_availability_zones.available.names[count.index]))
  availability_zone= "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags {
    Name = "PrivateSubnet"
  }
}
*/
