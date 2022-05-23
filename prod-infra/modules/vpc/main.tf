data "aws_availability_zones" "available" {
  state = "available"
}

#Subnetting 
module "mod_subnet_addr" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "Public Subnet 1"
      new_bits = 8
    },
    {
      name     = "Public Subnet 2"
      new_bits = 8
    },

    {
      name     = "Public Subnet 3"
      new_bits = 8
    },
    {
      name     = "Private Subnet 1"
      new_bits = 8
    },
    {
      name     = "Private Subnet 2"
      new_bits = 8
    },
    {
      name     = "Private Subnet 3"
      new_bits = 8
    },
    {
      name     = "DB Subnet 1"
      new_bits = 8
    },
    {
      name     = "DB Subnet 2"
      new_bits = 8
    }
  ]
}

#VPC Creation
module "notejam_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "${var.env}-vpc"
  cidr = var.vpc_cidr

  azs                                  = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  public_subnets                       = [module.mod_subnet_addr.network_cidr_blocks["Public Subnet 1"], module.mod_subnet_addr.network_cidr_blocks["Public Subnet 2"], module.mod_subnet_addr.network_cidr_blocks["Public Subnet 3"]]
  private_subnets                      = [module.mod_subnet_addr.network_cidr_blocks["Private Subnet 1"], module.mod_subnet_addr.network_cidr_blocks["Private Subnet 2"], module.mod_subnet_addr.network_cidr_blocks["Private Subnet 3"]]
  intra_subnets                        = [module.mod_subnet_addr.network_cidr_blocks["DB Subnet 1"], module.mod_subnet_addr.network_cidr_blocks["DB Subnet 2"]]
  enable_nat_gateway                   = true
  one_nat_gateway_per_az               = true
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  create_flow_log_cloudwatch_log_group = true


  public_subnet_tags = {
    Name                                       = "Public Subnets-${var.env}"
    "kubernetes.io/cluster/notejam-${var.env}" = "shared"
    "kubernetes.io/role/elb"                   = "1"
  }

  private_subnet_tags = {
    Name = "Private Subnets-${var.env}"
  }

  intra_subnet_tags = {
    Name = "RDS Subnets-${var.env}"

  }

  igw_tags = {
    Name = "${var.env}-IGW"

  }
  nat_gateway_tags = {
    Name = "${var.env}-NAT-GW"

  }


  tags = var.custom_tags
}