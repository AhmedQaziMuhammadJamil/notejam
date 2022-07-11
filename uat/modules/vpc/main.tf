data "aws_availability_zones" "available" {
  state = "available"
}

#Subnetting 
module "mod_subnet_addr" {
  source = "hashicorp/subnets/cidr"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "EKS-Control-Plane-SN-1"
      new_bits = 8
    },
    {
      name     = "EKS-Control-Plane-SN-2"
      new_bits = 8
    },
    {
      name     = "EKS-Control-Plane-SN-3"
      new_bits = 8
    },
    {
      name     = "Public-SN-1"
      new_bits = 8
    },
    {
      name     = "Public-SN-2"
      new_bits = 8
    },

    {
      name     = "Public-SN-3"
      new_bits = 8
    },
    {
      name     = "Private-SN-1"
      new_bits = 8
    },
    {
      name     = "Private-SN-2"
      new_bits = 8
    },
    {
      name     = "Private-SN-3"
      new_bits = 8
    },
    {
      name     = "DB-SN-1" ##TODO: Change the names
      new_bits = 8
    },
    {
      name     = "DB-SN-2"
      new_bits = 8
    },
    {
      name     = "DB-SN-3"
      new_bits = 8
    },
    {
      name     = "DB-SN-4"
      new_bits = 8
    },


  ]
}

#VPC Creation
module "uat_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "${var.env}-vpc"
  cidr = var.vpc_cidr

  azs                                  = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  public_subnets                       = [module.mod_subnet_addr.network_cidr_blocks["Public-SN-1"], module.mod_subnet_addr.network_cidr_blocks["Public-SN-2"], module.mod_subnet_addr.network_cidr_blocks["Public-SN-3"]]
  private_subnets                      = [module.mod_subnet_addr.network_cidr_blocks["Private-SN-1"], module.mod_subnet_addr.network_cidr_blocks["Private-SN-2"], module.mod_subnet_addr.network_cidr_blocks["Private-SN-3"]]
  database_subnets                     = [module.mod_subnet_addr.network_cidr_blocks["DB-SN-1"], module.mod_subnet_addr.network_cidr_blocks["DB-SN-2"]]
  elasticache_subnets                  = [module.mod_subnet_addr.network_cidr_blocks["DB-SN-3"], module.mod_subnet_addr.network_cidr_blocks["DB-SN-4"]]
  intra_subnets                        = [module.mod_subnet_addr.network_cidr_blocks["EKS-Control-Plane-SN-1"], module.mod_subnet_addr.network_cidr_blocks["EKS-Control-Plane-SN-2"], module.mod_subnet_addr.network_cidr_blocks["EKS-Control-Plane-SN-3"]]
  enable_nat_gateway                   = true
  one_nat_gateway_per_az               = true
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  create_flow_log_cloudwatch_log_group = true


  public_subnet_tags = {
    Name                                        = "Public-SN-${var.env}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
  private_subnet_tags = {
    Name                                        = "Private-SN-${var.env}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }


  database_subnet_tags = {
    Name = "DataBase-SN-${var.env}"
  }
  elasticache_subnet_tags = {
    Name = "ElasticCache-SN-${var.env}"
  }
  intra_subnet_tags = {
    Name = "EKS-Control-Plane-SN-${var.env}"

  }

  igw_tags = {
    Name = "${var.env}-IGW"

  }
  nat_gateway_tags = {
    Name = "${var.env}-NAT-GW"

  }


  tags = var.common_tags
}