output "account-id" {
  value = data.aws_caller_identity.current.account_id
}

/* output "zones-id" {
  value = module.route53_zones.route53_zone_zone_id
} */