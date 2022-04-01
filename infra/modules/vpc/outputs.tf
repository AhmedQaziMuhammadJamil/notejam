output "out_nl_vpcid" {
  value       = module.notejam_vpc.vpc_id
  description = "VPC ID"
}

output "out_nl_privatesubnet" {
  value       = module.notejam_vpc.private_subnets
  description = "Private Subnets"
}

output "out_nl_publicsubnet" {
  value       = module.notejam_vpc.public_subnets
  description = "Public Subnets"
}

output "out_nl_rdssubnet" {
  value       = module.notejam_vpc.intra_subnets
  description = "RDS Subnets"
}