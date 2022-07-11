output "vpc_id" {
  value       = module.uat_vpc.vpc_id
  description = "VPC ID"
}

output "private_subnets" {
  value       = module.uat_vpc.private_subnets
  description = "Private Subnets"
}

output "public_subnets" {
  value       = module.uat_vpc.public_subnets
  description = "Public Subnets"
}

output "eks_controlplane_eni_subnets" {
  value       = module.uat_vpc.intra_subnets
  description = "RDS Subnets"
}
